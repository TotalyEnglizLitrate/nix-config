{...}: {
  services.displayManager.enable = true;
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
