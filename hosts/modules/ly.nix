{pkgs, ...}: {
  services.displayManager = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "engliz";
    defaultSession = "hyprland";
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "weston";
    theme = "where_is_my_sddm_theme";
    package = pkgs.kdePackages.sddm;
    extraPackages = [
      pkgs.kdePackages.qt5compat
    ];
  };

  environment.systemPackages = [
    (pkgs.where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = "${../../files/wallpapers/nix-logo.png}";
        backgroundMode = "none";
      };
    })
  ];
}
