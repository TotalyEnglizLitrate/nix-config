{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./shell.nix
    ./git.nix
    ./home.nix
    ./lazygit.nix
    ./nvim.nix
    ./packages.nix
    ./scripts.nix
    ./starship.nix
    ./fastfetch.nix
    ./zellij.nix
    ./kubectl.nix
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

  home.file."Pictures/Wallpapers/default.png".source = ../../files/images/default-wallpaper.png;
}
