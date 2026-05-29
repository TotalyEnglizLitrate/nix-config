{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;

    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment = {
    systemPackages = [pkgs.protonup-ng];
    sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
