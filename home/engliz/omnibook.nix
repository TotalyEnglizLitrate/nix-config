{...}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/desktop/niri/home.nix
    ../../modules/desktop/mangowm/home.nix
  ];


  home.stateVersion = "24.11";
}
