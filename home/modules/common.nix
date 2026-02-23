{outputs, ...}: {
  imports = [
    ../modules/bluetuith.nix
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/home.nix
    ../modules/lazygit.nix
    ../modules/nvim.nix
    ../modules/obs-studio.nix
    ../modules/packages.nix
    ../modules/scripts.nix
    ../modules/fish.nix
    ../modules/starship.nix
    ../modules/zellij.nix
    ../modules/zen.nix
    ../modules/spicetify.nix
    ../modules/spotify.nix
    ../modules/stylix.nix
    ../modules/kubectl.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
  };

  home.file."Pictures/wallpapers/default.png".source = ../../files/wallpapers/nix-logo.png;
}
