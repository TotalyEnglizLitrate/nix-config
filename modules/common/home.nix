{
  outputs,
  osConfig,
  cfg,
  ...
}: {
  imports = [
    ./home-packages.nix
    ../shell/home.nix
    ../stylix/home.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  inherit (osConfig) cfg;

  home = let
    username = cfg.user.name;
  in {
    inherit username;
    homeDirectory = "/home/${username}";
    file."Pictures/Wallpapers/default.png".source = ../../files/images/default-wallpaper.png;
  };
}
