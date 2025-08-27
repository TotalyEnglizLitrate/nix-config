{...}: {
  services.displayManager.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    relogin = true;
  };
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
