# Pull-based deploys: the server periodically applies the config from the
# (public) repo with `nixos apply`, so CI never holds credentials for it.
# Only what's on master is deployed; push to roll out. No automatic reboot.
{
  config,
  lib,
  pkgs,
  ...
}: let
  flakeRef = "github:TotalyEnglizLitrate/nix-config#${config.cfg.host.hostname}";
in {
  systemd.services.nixos-auto-upgrade = {
    description = "Apply the NixOS configuration from the git repo";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    after = ["network-online.target"];
    wants = ["network-online.target"];

    # nixos apply shells out to these
    path = [config.nix.package config.programs.nixos-cli.package pkgs.nvd pkgs.nix-output-monitor pkgs.gitMinimal];
    environment.HOME = "/root";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.concatStringsSep " " [
        "${lib.getExe config.programs.nixos-cli.package} apply"
        (lib.escapeShellArg flakeRef)
        "--yes"
        "--use-nom=false"
      ];
    };
  };

  systemd.timers.nixos-auto-upgrade = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "04:00";
      RandomizedDelaySec = "30min";
      Persistent = true;
    };
  };
}
