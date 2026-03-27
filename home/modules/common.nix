{inputs, outputs, ...}: {
  imports = [
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/home.nix
    ../modules/lazygit.nix
    ../modules/nvim.nix
    ../modules/packages.nix
    ../modules/scripts.nix
    ../modules/fish.nix
    ../modules/starship.nix
    ../modules/zellij.nix
    ../modules/stylix.nix
    ../modules/kubectl.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.niri.overlays.niri
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
