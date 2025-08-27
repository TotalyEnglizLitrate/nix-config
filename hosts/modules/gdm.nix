{...}: {
  services.displayManager = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "engliz";
  };
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
