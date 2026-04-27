{
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    polarity = "dark";

    targets.qt.enable = true;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts._0xproto;
        name = "0xProto Nerd Font";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
    };
  };
}
