{...}: {
  imports = [
    ../modules/common.nix
    ../modules/niri.nix
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
