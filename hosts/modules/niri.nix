{inputs, pkgs, ...}: {
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  services.xserver.updateDbusEnvironment = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  environment.systemPackages = [ pkgs.polkit_gnome ];
}
