# NixOS configurations
*Forked from [Alexander Nabokikh's config](https://github.com/AlexNabokikh/nix-config); diverged significantly since.*

## Overview
Personal NixOS + Home Manager configuration spanning 4 machines, The core design is a typed `cfg` option namespace (`hosts/common.nix`) that lets ~20 feature modules read host capabilities (GPU, laptop, fingerprint reader, displays) instead of hardcoding per-machine values, adding a new host is writing one profile.nix file, not touching the modules themselves.

## Layout

```
flake.nix                    - entry point: builders + outputs
hosts/
  common.nix                 - declares the cfg.user / cfg.host option types
  <hostname>/
    configuration.nix        - NixOS-only: hardware, boot, filesystem, imports
    hardware-configuration.nix
    profile.nix              - used by both NixOS and HM: portable cfg.host VALUES (displays, gpu, laptop, ...)
home/
  <username>/
    <hostname>.nix           - per-(user,host) home-manager entrypoint
modules/
  common/
    host.nix                 - NixOS-wide baseline, imported by every host
    home.nix                 - HM-wide baseline, imported by every home profile
  <feature>/
    host.nix                 - NixOS side of a feature (e.g. modules/desktop/niri/host.nix)
    home.nix                 - HM side of the same feature
overlays.nix                 - nixpkgs overlays, exposed as outputs.overlays.*
.tack/                       - input pinning (see .tack/pins.toml), produces `inputs`
```

The one thing to internalize up front: **`cfg` is a hand-rolled option namespace**, declared once in `hosts/common.nix` and values defined in `hosts/<host>/profile.nix`
- `cfg.user.*` has name/email/shell/signing keys
- `cfg.host.*` has hostname, displays, gpu flags, laptop/webcam/bluetooth/fprint/IRCam booleans).
Almost every feature module reads from `config.cfg.*` instead of hardcoding per-machine values, so most modules don't change per host only `hosts/<hostname>/profile.nix` and `flake.nix`'s `cfg.user` assignment do.

## The three build shapes

`flake.nix` exposes three ways a config can come together, all built from the
same `hosts/`, `modules/`, and `home/` trees:

1. **NixOS with Home Manager as a NixOS module** (`nixosConfigurations.*`): the normal case for a physical machine. One `nixos-rebuild switch` builds system + user environment together.
2. **NixOS without Home Manager**: same builder, just don't wire the `home-manager` NixOS module in (see below).
3. **Home Manager standalone** (`homeConfigurations.*`): no NixOS underneath.


## Adding a new host with HM as a NixOS module

This is what `latitude5491`, `omnibook`, `wanderer` all do.

1. **Generate hardware config.**
   ```bash
   mkdir -p hosts/myhost
   sudo nixos-generate-config --dir hosts/myhost/
   sudo chown $(whoami):$(whoami) hosts/myhost/*
   chmod u+rw hosts/myhost/
   ```

2. **Write `hosts/myhost/profile.nix`**: just the portable `cfg.host` values for this machine (see `hostType` in `hosts/common.nix` for the full option list):
   ```nix
   _: {
     cfg.host = {
       displays.eDP-1 = {
         resolution = { width = 1920; height = 1080; };
         scale = 1.0;
       };
       laptop = true;
       webcam = true;
       gpu.amd = true;      # or gpu.nvidia, or neither
     };
   }
   ```
   Leave out anything that should stay at its `hostType` default (bluetooth defaults on, fprint/IRCam default off, etc., check `hosts/common.nix`).

3. **Write `hosts/myhost/configuration.nix`**: the NixOS-only stuff (imports, boot loader, filesystem quirks, firewall):
   ```nix
   {inputs, ...}: {
     imports = [
       ./hardware-configuration.nix
       ./profile.nix
       ../../modules/common/host.nix
       ../../modules/desktop/niri/host.nix   # pick the features this host wants
     ];

     nixpkgs.config.allowUnfree = true;
     system.stateVersion = "24.11";
   }
   ```
   Only import the *feature* `host.nix` modules this machine actually wants (desktop environment, dual-function-keys, docker, zram etc., see `modules/` for the full list). `modules/common/host.nix` is the one baseline every host imports.

4. **Write `home/<username>/myhost.nix`**: the HM entrypoint for this (user, host) pair:
   ```nix
   _: {
     imports = [
       ../../modules/common/home.nix
       ../../modules/desktop/niri/home.nix   # match whatever host.nix modules you picked
     ];

     systemd.user.startServices = "sd-switch";
     home.stateVersion = "24.11";
   }
   ```
   The convention is: whatever `<feature>/host.nix` you import in `configuration.nix`, import the matching `<feature>/home.nix` here too.

5. **Register the user (once), if new.** In `flake.nix`'s `users` attrset:
   ```nix
   users.myuser = {
     name = "myuser";
     fullName = "...";
     email = "...";
     signingKeys = [ ... ];   # optional
     shell = "fish";           # optional, defaults to fish
   };
   ```

6. **Add the output** in `flake.nix`:
   ```nix
   nixosConfigurations.myhost = mkNixosConfiguration "myhost" "myuser";
   ```

7. Build/switch:
   ```bash
   sudo nixos-rebuild switch --flake .#myhost
   ```

## Adding a HM-only profile (no matching NixOS host)

For non-NixOS boxes (another distro, WSL etc.).

1. **Write `hosts/<hostname>/profile.nix`** the same as above. It's already portable (no NixOS-only imports), so it's reused as-is by both build shapes. If the host has no NixOS counterpart, this can live purely as an HM-only profile; the filename convention is just for consistency.

2. **Write `home/<username>/<hostname>.nix`**, same as the NixOS-integrated case, same imports convention (`modules/common/home.nix` baseline + whichever feature `home.nix` files you want, e.g. `niri/home.nix`, `mangowm/home.nix`).

3. **Register a `mkHomeConfiguration` output** in `flake.nix`:
   ```nix
   homeConfigurations."myuser@myhost" = mkHomeConfiguration "myhost" "myuser" "x86_64-linux";
   ```
   `mkHomeConfiguration` (in `flake.nix`) builds `pkgs` itself, and imports `hosts/common.nix` + `hosts/<hostname>/profile.nix` + Stylix's *home* module (`inputs.stylix.homeModules.stylix`, not the NixOS one) + `modules/stylix/host.nix` for the actual theme config (its option names are identical between the NixOS and HM Stylix modules, so it's reusable as-is) + a `cfg.user`/`cfg.host.hostname` value block + your `home/<user>/<host>.nix`.

4. Build/switch (needs the `home-manager` CLI installed, add it to your profile)
   ```bash
   home-manager switch --flake .#myuser@myhost
   ```



## How the module imports are structured

Each feature under `modules/<feature>/` is typically a pair:

- `host.nix`: the NixOS-side config (system packages, services, kernel modules, systemd units, etc). Takes `{ config, lib, pkgs, inputs, outputs, ... }` as needed.
- `home.nix`: the HM-side config for the same feature (user packages, dotfiles, `xdg.configFile`, `systemd.user.services`, etc).

A host wires in the `host.nix` side via `hosts/<hostname>/configuration.nix`; the matching user wires in the `home.nix` side via `home/<username>/<hostname>.nix`. They're independent imports, nothing forces them to be paired, but in practice you almost always want both for a given feature on a given host.

`modules/common/host.nix` and `modules/common/home.nix` are the two baselines every NixOS host / every HM profile pulls in respectively. They bundle things every machine wants regardless of desktop environment: nix settings, unfree/ROCm config (`modules/common/host.nix` reads `config.cfg.host.gpu.amd` to decide `rocmSupport`), the flake registry, a kernel overlay, and (on the NixOS side) a handful of always-on modules like `cloudflare-warp`, `tailscale`, `wireshark`, `nixos-cli`, `stylix`, `llama`.

### Adding something to the common baseline

Edit `modules/common/host.nix` (system-wide) or `modules/common/home.nix` (user-wide) directly, either add the config inline, or (preferred for anything nontrivial) create `modules/<newthing>/host.nix` / `modules/<newthing>/home.nix` and add it to the `imports` list in `modules/common/{host,home}.nix`. Only do this for things you want on **every** host/profile; anything host-specific belongs in that feature's own module, imported only by the hosts that want it.

### Removing something from the common baseline

Same idea in reverse. If e.g. `wireshark` shouldn't be everywhere, delete its line from `modules/common/host.nix`'s `imports` and instead add `../wireshark/host.nix` to just the specific `hosts/<hostname>/configuration.nix` files that want it.

### Gating a module by hardware/host capability

Feature modules that only make sense conditionally read `config.cfg.host.*` directly rather than being conditionally imported, e.g.:

```nix
# inside some host.nix
config = lib.mkIf config.cfg.host.fprint {
  services.fprintd.enable = true;
};
```

This is the preferred pattern over `lib.mkIf` scattered through `hosts/<hostname>/configuration.nix`, put the conditional inside the feature module, keyed off `cfg.host`, so the module is always safe to import everywhere and simply no-ops on hosts that don't have the capability.



## Overlays

`overlays.nix` returns an attrset of overlay functions (kernel pin, `spotify`, `nvim`, `helium`, `nixcu`, and passthroughs for `niri`, `mango`, `noctalia`, `claude-code` from their respective flake inputs), exposed as `outputs.overlays.<name>`. 

Reference them from a NixOS module with `nixpkgs.overlays = [ outputs.overlays.kernelOverlay ];`. For the NixOS-integrated HM case, HM inherits the system `pkgs` automatically. For standalone `mkHomeConfiguration` builds, apply the same `config.allowUnfree`/overlay list to the `pkgs` it constructs if a home profile needs a package from one of these overlays.

## Inputs

Inputs are pinned via `.tack/` (see [the tack repo](https://github.com/manic-systems/tack)) rather than a plain flake `inputs` block `flake.nix` calls `import ./.tack { overrides = ...; }` to produce the `inputs` attrset used everywhere else. Add a new flake input there, not in `flake.nix`.

## Quick reference

| I want to... | Do this |
|---|---|
| Add a new NixOS+HM host | `hosts/<h>/{configuration,profile,hardware-configuration}.nix` + `home/<u>/<h>.nix` + `nixosConfigurations.<h> = mkNixosConfiguration "<h>" "<u>";` |
| Add an HM-only profile | `hosts/<h>/profile.nix` + `home/<u>/<h>.nix` + `homeConfigurations."<u>@<h>" = mkHomeConfiguration "<h>" "<u>" "<system>";` |
| Add a new user | New entry in `flake.nix`'s `users` attrset |
| Add a feature to every host | Add its `host.nix`/`home.nix` import to `modules/common/{host,home}.nix` |
| Add a feature to one host only | Import `modules/<feature>/host.nix` / `home.nix` directly in that host's `configuration.nix` / `home/<u>/<h>.nix` |
| Gate config on hardware capability | `lib.mkIf config.cfg.host.<flag> { ... }` inside the feature module, not a conditional import |

## License

All code contained in this repository is released under the same MIT license as the original repository.
