{...}: {
  imports = [
    ../modules/common.nix
    ../modules/niri.nix
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.hyprlock.settings.auth."fingerprint:enable" = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
