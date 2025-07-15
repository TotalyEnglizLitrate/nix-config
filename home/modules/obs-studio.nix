{pkgs, ...}: {
  config = {
    # Install OBS Studio via home-manager module
    programs.obs-studio = {
      enable = true;
      plugins = [pkgs.obs-studio-plugins.wlrobs];
    };

    # Enable catppuccin theming for OBS.
    catppuccin.obs.enable = true;
  };
}
