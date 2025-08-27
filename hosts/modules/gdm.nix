{...}: {
  services.displayManager.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "engliz";
  };
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
