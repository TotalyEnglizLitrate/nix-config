{outputs, ...}: let
  scripts = ./../../files/scripts;
in {
  nixpkgs.overlays = [outputs.overlays.niri];

  home.file = {
    ".local/bin" = {
      recursive = true;
      source = "${scripts}";
    };
  };
}
