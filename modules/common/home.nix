{
  outputs,
  userConfig,
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
  home = {
    username = "${userConfig.name}";
    homeDirectory = "/home/${userConfig.name}";
  };

  home.file."Pictures/Wallpapers/default.png".source = ../../files/images/default-wallpaper.png;
}
