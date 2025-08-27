{...}: {
  services.displayManager.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
