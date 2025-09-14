{pkgs, ...}: let
  swaync_config = ./../../files/configs/swaync;
in {
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  xdg.configFile = {
    "swaync" = {
      recursive = true;
      source = "${swaync_config}";
    };
  };
}
