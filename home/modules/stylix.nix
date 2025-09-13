{
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    targets = {
      bat.enable = true;
      btop.enable = true;
      lazygit.enable = true;
      foot.enable = true;
      starship.enable = true;
      swaync.enable = true;
      waybar.enable = true;
      qt.enable = true;
      gtk.enable = true;
      zellij.enable = true;
      spicetify.enable = true;
    };
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
