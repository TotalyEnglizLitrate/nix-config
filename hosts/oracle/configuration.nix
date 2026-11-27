{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./profile.nix
    ../../modules/server/host.nix
    ../../modules/server/auto-upgrade.nix
    ../../modules/stylix/server.nix
    ../../modules/vaultwarden/host.nix
    ../../modules/jellyfin/host.nix
    ../../modules/jellyfin/r2.nix
  ];

  # media lives in R2 (read-only) with a local cache and a local layer for subtitles;
  # see modules/jellyfin/r2.nix. shrink the cache if the boot volume is large
  custom.jellyfin.r2 = {
    enable = true;
    bucket = "jellyfin";
    cacheMaxSize = "100G";
  };

  # temporary public sign-up page at https://jellyfin.engliz.dev/signup.
  # flip to true and push to open it, back to false once everyone has joined
  custom.jellyfin.signup.enable = true;

  # Oracle Ampere A1 (4 OCPU / 24 GB)
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    # serial console for the Oracle console connection
    kernelParams = ["console=ttyAMA0,115200" "console=tty1"];
  };

  system.stateVersion = "26.05";
}
