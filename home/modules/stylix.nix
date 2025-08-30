{pkgs, ...}: {
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
  stylix.targets = {
    foot.enable = true;
    fish.enable = true;
    starship.enable = true;
    bat.enable = true;
    btop.enable = true;
    lazygit.enable = true;
    swaync.enable = true;
    waybar.enable = true;
    qt.enable = true;
    gtk.enable = true;
    spicetify.enable = true;
  };
}
