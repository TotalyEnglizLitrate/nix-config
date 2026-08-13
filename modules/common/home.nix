{config, ...}: {
  imports = [
    ./home-packages.nix
    ../shell/home.nix
    ../stylix/home.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  systemd.user.startServices = "sd-switch";

  home = let
    username = config.cfg.user.name;
  in {
    inherit username;
    homeDirectory = "/home/${username}";
    file."Pictures/Wallpapers/default.png".source = ../../files/images/default-wallpaper.png;
  };
}
