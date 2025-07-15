{pkgs, ...}: {
  services.displayManager.enable = true;
  services.displayManager.ly = {
    enable = true;
    x11Support = false;
    package = pkgs.ly;
  };
}
