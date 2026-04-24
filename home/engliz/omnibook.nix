{...}: {
  imports = [
    ../modules/common.nix
    ../modules/wm/niri.nix
  ];

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
