{...}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/desktop/niri/home.nix
  ];

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
