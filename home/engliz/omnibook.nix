{...}: {
  imports = [
    ../modules/common.nix
    ../modules/niri.nix
  ];

  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.hyprlock.settings.auth."fingerprint:enable" = true;

  home.stateVersion = "24.11";
}
