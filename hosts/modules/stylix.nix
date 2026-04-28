{
  lib,
  pkgs,
  ...
}: let
  font = {
    package = pkgs.nerd-fonts._0xproto;
    name = "0xProto Nerd Font";
  };
in {
  stylix = {
    enable = true;
    base16Scheme = ../../files/themes/tokyo-night-terminal-dark.yaml;
    polarity = "dark";
    opacity.terminal = 0.9;

    targets.qt.enable = true;

    fonts =
      {
        emoji = {
          package = pkgs.twitter-color-emoji;
          name = "Twitter Color Emoji";
        };
      }
      // lib.genAttrs ["monospace" "serif" "sansSerif"] (_: font);
  };
}
