{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../modules/shell.nix
    ../modules/git.nix
    ../modules/home.nix
    ../modules/lazygit.nix
    ../modules/nvim.nix
    ../modules/packages.nix
    ../modules/scripts.nix
    ../modules/starship.nix
    ../modules/zellij.nix
    ../modules/stylix.nix
    ../modules/kubectl.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.niri.overlays.niri
      inputs.claude-code.overlays.default
    ];

    config = {
      allowUnfree = true;
    };
  };

  programs.btop.enable = true;

  home.file."Pictures/wallpapers/default.png".source = ../../files/wallpapers/nix-logo.png;
}
