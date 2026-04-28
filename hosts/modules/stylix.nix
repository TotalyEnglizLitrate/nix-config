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

    icons = {
      enable = true;
      dark = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

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
