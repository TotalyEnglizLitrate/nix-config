{...}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/desktop/niri/home.nix
  ];

  home.stateVersion = "24.11";
}
