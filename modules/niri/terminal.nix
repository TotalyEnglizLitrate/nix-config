{
  pkgs,
  lib,
  ...
}: {
  cfg.commands = {
    terminal.package = pkgs.ghostty;
    sysmon = {
      package = pkgs.ghostty;
      args = ["-e" "${pkgs.btop}/bin/btop"];
    };
  };
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings.font-size = lib.mkForce 16;
  };
}
