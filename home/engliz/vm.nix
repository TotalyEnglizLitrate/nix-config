{...}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/niri/home.nix
  ];

  home.stateVersion = "24.11";
}
