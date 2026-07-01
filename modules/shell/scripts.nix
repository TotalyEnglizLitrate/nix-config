{inputs, ...}: let
  scripts = ./../../files/scripts;
in {
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    inputs.noctalia.overlays.default
  ];

  home.file = {
    ".local/bin" = {
      recursive = true;
      source = "${scripts}";
    };
  };
}
