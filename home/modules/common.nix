{
  lib,
  config,
  inputs,
  outputs,
  ...
}: let
  stylix-kde-theme = lib.findFirst (pkg: pkg.name == "stylix-kde-theme") null config.home.packages;
  schemePath = config.stylix.base16Scheme;
  schemeFileName = lib.removeSuffix ".yaml" (baseNameOf schemePath);
  toPascalCase = str:
    lib.concatMapStrings (word: lib.toUpper (lib.substring 0 1 word) + lib.substring 1 (-1) word) (
      lib.splitString "-" str
    );
  colorFileName = "${toPascalCase schemeFileName}.colors";
in {
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

  home.file.".config/kdeglobals".source = "${stylix-kde-theme}/share/color-schemes/${colorFileName}"; # kde connect
  home.file."Pictures/Wallpapers/default.png".source = ../../files/images/default-wallpaper.png;
}
