_: {
  imports = [../../modules/shell/core.nix];

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "26.05";
}
