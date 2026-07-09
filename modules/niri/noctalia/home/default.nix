{
  lib,
  pkgs,
  inputs,
  outputs,
  config,
  osConfig,
  ...
}: let
  sysmon = ["cpu" "temp" "ram" "network_rx" "network_tx"];
in {
  imports = [
    inputs.noctalia.homeModules.default
    ./theme.nix
  ];

  nixpkgs.overlays = [outputs.overlays.noctalia];

  programs.noctalia = {
    package = pkgs.noctalia;
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "stylix";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      shell = {
        setup_wizard_enabled = false;
        settings_show_advanced = true;
        show_location = false;
        screen_time_enabled = true;
        animation.speed = 2.0;
        font_family = "0xProtoNerdFontPropo";
        panel = {
          transparency_mode = "soft";
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
            sysmon
            ++ ["tray" "network"]
            ++ lib.optional osConfig.cfg.host.bluetooth "bluetooth"
            ++ ["volume" "brightness" "privacy" "battery"];
          thickness = 40;
          scale = 1.3;
          radius = 0;
        };
      };

      widget =
        {
          clock.format = "{:%a, %d %b} {:%H:%M}";
          battery.capsule = true;
          brightness.capsule = true;
          volume.capsule = true;
          privacy = {
            capsule = true;
            capsule_fill = "primary";

            active_color = "outline";
            hide_inactive = true;
          };

          tray.drawer = true;
          network.show_label = false;
        }
        // builtins.listToAttrs (map (name: {
            inherit name;
            value = {
              display = "text";
              scale = 0.85;
            };
          })
          sysmon);

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-widget-media_player"
          "lockscreen-widget-visualizer"
          "lockscreen-login-box"
          "lockscreen-widget-clock"
          "lockscreen-widget-cpu_usage"
          "lockscreen-widget-cpu_temp"
          "lockscreen-widget-ram_usage"
        ];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = {
          "lockscreen-login-box" = {
            box_height = 64.0;
            box_width = 384.0;
            cx = 1128.0;
            cy = 1298.0;
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };

          "lockscreen-widget-clock" = {
            box_height = 160.0;
            box_width = 432.0;
            cx = 1120.0;
            cy = 252.0;
            rotation = 0.0;
            type = "clock";

            settings = {
              center_text = true;
              format = "{:%a, %d %b}\\n{:%H:%M:%S}";
            };
          };

          "lockscreen-widget-media_player" = {
            box_height = 192.0;
            box_width = 736.0;
            cx = 1088.0;
            cy = 1060.0;
            rotation = -0.0;
            type = "media_player";

            settings = {
              layout = "horizontal";
            };
          };

          "lockscreen-widget-cpu_usage" = {
            box_height = 48.0;
            box_width = 96.0;
            cx = 1392.0;
            cy = 1004.0;
            rotation = 0.0;
            type = "sysmon";

            settings = {
              display = "gauge";
              stat = "cpu_usage";
              stat2 = "cpu_temp";
            };
          };

          "lockscreen-widget-cpu_temp" = {
            box_height = 48.0;
            box_width = 96.0;
            cx = 1392.0;
            cy = 1060.0;
            rotation = 0.0;
            type = "sysmon";

            settings = {
              display = "gauge";
              stat = "cpu_temp";
              stat2 = "cpu_temp";
            };
          };

          "lockscreen-widget-ram_usage" = {
            box_height = 48.0;
            box_width = 96.0;
            cx = 1392.0;
            cy = 1116.0;
            rotation = 0.0;
            type = "sysmon";

            settings = {
              display = "gauge";
              stat = "ram_pct";
              stat2 = "cpu_temp";
            };
          };

          "lockscreen-widget-visualizer" = {
            box_height = 160.0;
            box_width = 128.0;
            cx = 800.0;
            cy = 1060.0;
            rotation = 0.0;
            type = "fancy_audio_visualizer";

            settings = {
              background = false;
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
        screen-off = {
          timeout = 90;
          action = "screen_off";
        };

        lock = {
          timeout = 300;
          action = "lock";
        };

        suspend = {
          timeout = 900;
          action = "lock_and_suspend";
        };
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
