{pkgs, ...}: let
  swaync_config = ./../../../files/configs/swaync;
in {
  stylix.targets.swaync.enable = true;

  home.packages = with pkgs; [
    libnotify
    swaynotificationcenter
  ];

  xdg.configFile = {
    "swaync" = {
      recursive = true;
      source = "${swaync_config}";
    };
  };
}
