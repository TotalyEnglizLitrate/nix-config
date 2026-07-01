{
  lib,
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
    ./theme.nix
  ];

  nixpkgs.overlays = [inputs.noctalia.overlays.default];

  programs.noctalia = {
    package = pkgs.noctalia;
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "stylix";
      };

      shell = {
        setup_wizard_enabled = false;
        settings_show_advanced = true;
        show_location = false;
        screen_time_enabled = true;
        animation.speed = 2.0;
        panel = {
          transparency_mode = "soft";
          session_placement = "centered";
          open_near_click_control_center = true;
          open_near_click_wallpaper = true;
        };
        launcher.categories = false;
        greeter_sync = {
          auto_sync = true;
          privilege_command = "pkexec";
        };
      };

      osd.position = "top_right";

      bar = {
        order = ["main"];
        main = {
          margin_ends = 0;
          margin_edge = 0;

          start = ["workspaces" "active_window"];
          center = ["notifications" "clock"];
          end =
            ["sysmon" "tray" "network"]
            ++ lib.optional osConfig.cfg.host.bluetooth "bluetooth"
            ++ ["volume" "brightness" "privacy" "battery" "control-center"];
        };
      };

      widget.clock.format = "{:%a, %d %b} {:%H:%M}";

      lockscreen_widgets = {
        enabled = true;
        widget = {
          clock = {
            type = "clock";
            output = "eDP-1";
            cx = 960.0;
            cy = 540.0;
            box_width = 0.0;
            box_height = 0.0;
            rotation = 0.0;
            settings = {
              clock_style = "digital";
              format = "{:%a, %d %b}\n{:%H:%M}";
            };
          };

          media = {
            type = "media_player";
            output = "eDP-1";
            cx = 500.0;
            cy = 700.0;
            box_width  = 0.0;
            box_height = 0.0;
            rotation = 0.0;

            settings = {
              layout = "horizontal";
              color  = "on_surface";
              shadow = true;
              hide_when_no_media = true;
            };
          };
        };
      };

      dock.enabled = false;
      audio = {
        enable_overdrive = true;
        enable_sounds = true;
      };
      brightness.minimum_brightness = 0.0;

      idle.behavior = {
        screen-off.timeout = 90;
        lock.timeout = 300;
        suspend.timeout = 900;
      };

      wallpaper = let
        wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";
      in {
        directory = wallpaperDir;
        default = "${wallpaperDir}/default.png";
      };
    };
  };
}
