# Pull-based deploys, no CI credentials needed on either side:
#   1. nixos-config-pull (as the login user, hourly) fast-forwards a checkout of the
#      (public) repo in $NIXOS_CONFIG_DIR
#   2. nixos-auto-upgrade (as root) applies it with `nixos apply`, which picks the
#      flake ref up from $NIXOS_CONFIG
# Only what's on master is deployed; push to roll out. No automatic reboot.
{
  config,
  lib,
  pkgs,
  ...
}: let
  user = config.cfg.user.name;
  repoUrl = "https://github.com/TotalyEnglizLitrate/nix-config.git";
  # both set system-wide by modules/nixos-cli/host.nix
  configDir = config.environment.variables.NIXOS_CONFIG_DIR;
  nixosCli = config.programs.nixos-cli.package;
in {
  environment.systemPackages = [pkgs.rsync];

  # root evaluates a checkout owned by the login user
  programs.git = {
    enable = true;
    config.safe.directory = [configDir];
  };

  systemd.services.nixos-config-pull = {
    description = "Pull the NixOS configuration repo into ${configDir}";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    path = [pkgs.gitMinimal];
    environment.NIXOS_CONFIG_DIR = configDir;
    serviceConfig = {
      Type = "oneshot";
      User = user;
    };
    script = ''
      if [ -d "$NIXOS_CONFIG_DIR/.git" ]; then
        git -C "$NIXOS_CONFIG_DIR" pull --ff-only
      else
        git clone ${lib.escapeShellArg repoUrl} "$NIXOS_CONFIG_DIR"
      fi
    '';
  };

  systemd.services.nixos-auto-upgrade = {
    description = "Apply the NixOS configuration from ${configDir}";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    # a failed pull stops the switch, so a stale checkout is never re-applied silently
    requires = ["nixos-config-pull.service"];
    after = ["nixos-config-pull.service" "network-online.target"];
    wants = ["network-online.target"];

    # nixos apply shells out to these
    path = [config.nix.package nixosCli pkgs.nvd pkgs.nix-output-monitor pkgs.gitMinimal];
    environment = {
      HOME = "/root";
      NIXOS_CONFIG_DIR = configDir;
      # default flake ref of `nixos apply`
      NIXOS_CONFIG = config.environment.variables.NIXOS_CONFIG;
    };

    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.concatStringsSep " " [
        "${lib.getExe nixosCli} apply"
        "--yes"
        "--use-nom=false"
      ];
    };
  };

  systemd.timers.nixos-auto-upgrade = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "hourly";
      RandomizedDelaySec = "10min";
      Persistent = true;
    };
  };
}
