{outputs, ...}: let
  scripts = ./../../files/scripts;
in {
  nixpkgs.overlays = [
    outputs.overlays.niri
    outputs.overlays.noctalia
  ];

  home.file = {
    ".local/bin" = {
      recursive = true;
      source = "${scripts}";
    };
  };
}
