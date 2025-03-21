{...}: {
  imports = [
    ../modules/common.nix
    ../modules/easyeffects.nix
    ../modules/hyprland.nix
    ../modules/ulauncher.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
