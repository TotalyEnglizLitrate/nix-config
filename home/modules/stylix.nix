{pkgs, ...}: {
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
  stylix.targets = {
    bat.enable = true;
    btop.enable = true;
    fish.enable = true;
    foot.enable = true;
    river.enable = true;
    spicetify.enable = true;
    starship.enable = true;
    swaync.enable = true;
    waybar.enable = true;
    qt.enable = true;
  };
}
