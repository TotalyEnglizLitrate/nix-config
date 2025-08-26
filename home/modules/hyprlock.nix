{
  lib,
  pkgs,
  userConfig,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          path = "/home/${userConfig.name}/Pictures/wallpapers/default.png";
          blur_passes = 1;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      general = {
        no_fade_in = true;
        grace = 0;
        disable_loading_bar = true;
      };

      input-field = [
        {
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0.0)";
          inner_color = "rgba(17, 17, 81, 0.36)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          caslock_color = -1;
          placeholder_text = "Password";
          fail_text = "$FAIL ($ATTEMPTS)";
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          text = "cmd[update:3600000] echo $(date '+%A, %d %B')";
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 30;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] echo $(date '+%H:%M:%S')";
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 70;
          position = "0, 120";
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          halign = "center";
          valign = "center";
        }
      ];
    };
    package = pkgs.hyprlock;
  };
}
