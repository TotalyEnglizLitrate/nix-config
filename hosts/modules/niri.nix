{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    xserver.updateDbusEnvironment = true;
  };
  security = {
    polkit.enable = true;
  };

  environment.systemPackages = [pkgs.polkit_gnome];
}
