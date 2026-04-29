{
  pkgs,
  inputs,
  ...
}: let
  scripts = ./../../files/scripts;
in {
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    inputs.noctalia.overlays.default
  ];

  home.packages = [
    (pkgs.writeShellScriptBin "wallpaper" ''
      if [ -n "$1" ]; then
        WALLPAPER="$1"
        if [ ! -f "$1" ]; then
          echo "Error: Wallpaper file '$1' does not exist" >&2
        fi
      else
        WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
        WALLPAPER=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | ${pkgs.coreutils}/bin/shuf -n 1)
      fi

      if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
        exit 1
      fi

      OUTPUTS=$(${pkgs.niri-unstable}/bin/niri msg --json outputs | ${pkgs.jq}/bin/jq -r 'keys[]')
      for OUTPUT in $OUTPUTS; do
        ${pkgs.noctalia-shell}/bin/noctalia-shell ipc call wallpaper set "$WALLPAPER" "$OUTPUT"
      done
    '')
  ];

  home.file = {
    ".local/bin" = {
      recursive = true;
      source = "${scripts}";
    };
  };
}
