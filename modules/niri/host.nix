{
  lib,
  outputs,
  pkgs,
  config,
  ...
}: let
  inherit (config.cfg.host) bluetooth;
in {
  imports = [./noctalia/host.nix];
  nixpkgs.overlays = [outputs.overlays.niri];
  nix.settings = {
    substituters = lib.mkAfter ["https://niri-nix.cachix.org"];
    trusted-public-keys = ["niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="];
  };

  hardware.bluetooth = {
    enable = bluetooth;
    powerOnBoot = true;
  };

  users.users.${config.cfg.user.name}.extraGroups = [
    "input"
    "video"
  ];

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
