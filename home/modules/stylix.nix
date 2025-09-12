{pkgs, ...}: {
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
  stylix.targets = {
    bat.enable = true;
    btop.enable = true;
    lazygit.enable = true;
    neovim.enable = true;
    swaync.enable = true;
    waybar.enable = true;
    qt.enable = true;
    gtk.enable = true;
    tmux.enable = true;
    spicetify.enable = true;
  };
}
