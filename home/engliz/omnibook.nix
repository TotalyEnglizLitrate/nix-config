{...}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/desktop/niri/home.nix
    ../../modules/desktop/mangowm/home.nix
  ];

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
