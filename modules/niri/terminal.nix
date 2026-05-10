{
  pkgs,
  lib,
  config,
  ...
}: {
  commands = {
    terminal = {inherit (config.programs.ghostty) package;};
    sysmon = {
      inherit (config.commands.terminal) package;
      args = ["-e" "${pkgs.btop}/bin/btop"];
    };
  };
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings.font-size = lib.mkForce 16;
  };
}
