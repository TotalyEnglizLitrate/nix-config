{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (config.cfg.host) bluetooth;
in {
  imports = [./noctalia/host.nix];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  nix.settings = {
    extra-substituters = lib.mkAfter ["https://niri.cachix.org"];
    trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
  };
  niri-flake.cache.enable = false;
  systemd.user.services.niri-flake-polkit.enable = false;

  hardware.bluetooth = {
    enable = bluetooth;
    powerOnBoot = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services = {
    gvfs.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
    };
    xserver.updateDbusEnvironment = true;
  };
  security = {
    polkit = {
      enable = true;
      enablePkexecWrapper = true;
    };
  };

  environment.systemPackages = [
    pkgs.polkit_gnome
    pkgs.xwayland-satellite-unstable
  ];
}
