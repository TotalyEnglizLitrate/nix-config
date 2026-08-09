{pkgs, ...}: {
  imports = [
    ./commands.nix
    ./gtk.nix
    ./kanshi.nix
    ./packages.nix
    ./spotify.nix
    ./terminal.nix
    ./xdg.nix
    ../noctalia/home
  ];

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}
