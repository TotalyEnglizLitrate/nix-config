{...}: {
  imports = [
    ../modules/common.nix
    ../modules/wm/niri.nix
  ];

  systemd.user.startServices = "sd-switch";

  programs.hyprlock.settings.auth."fingerprint:enable" = true;

  home.stateVersion = "24.11";
}
