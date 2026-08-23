{...}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/desktop/niri/home.nix
    ../../modules/desktop/mangowm/home.nix
    ../../modules/desktop/umbriel/home
  ];

  home.stateVersion = "24.11";
}
