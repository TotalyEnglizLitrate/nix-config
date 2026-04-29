{...}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/niri/home.nix
  ];

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
