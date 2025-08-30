{outputs, ...}: {
  imports = [
    ../modules/fastfetch.nix
    ../modules/easyeffects.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/go.nix
    ../modules/gpg.nix
    ../modules/home.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    ../modules/obs-studio.nix
    ../modules/packages.nix
    ../modules/scripts.nix
    ../modules/fish.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/zen.nix
    ../modules/spicetify.nix
    ../modules/spotify.nix
    ../modules/stylix.nix
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
  };

  # include wallpapers
  home.file."Pictures/wallpapers/default.png".source = ../../files/wallpapers/nix-logo.png;
}
