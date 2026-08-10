{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.cfg.host) bluetooth;

  portals = [
    "xdg-desktop-portal"
    "xdg-desktop-portal-gnome"
    "xdg-desktop-portal-gtk"
    "xdg-desktop-portal-wlr"
  ];
in {
  imports = [../noctalia/host.nix];

  # Portals are D-Bus activated, so nothing stops them when a compositor exits.
  # Switching WMs then re-uses a daemon that already resolved its backends against
  # the previous XDG_CURRENT_DESKTOP. PartOf makes logout tear them down so the
  # next login re-activates them against the right one.
  systemd.user.services = lib.genAttrs portals (_: {
    overrideStrategy = "asDropin";
    unitConfig.PartOf = ["graphical-session.target"];
  });

  hardware.bluetooth = {
    enable = bluetooth;
    powerOnBoot = true;
  };

  users.users.${config.cfg.user.name}.extraGroups = [
    "input"
    "video"
  ];

  services = {
    gvfs.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
    };
    xserver.updateDbusEnvironment = true;
  };

  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };

  environment.systemPackages = [pkgs.polkit_gnome];
}
