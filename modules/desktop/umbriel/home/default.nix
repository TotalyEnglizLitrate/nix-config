{
  lib,
  pkgs,
  inputs,
  outputs,
  config,
  ...
}: let
  noctalia = lib.getExe pkgs.noctalia;
  noctaliaIPC = [noctalia "msg"];
  displays = config.cfg.host.displays;
  spawn = cmd: "spawn:${lib.escapeShellArgs cmd}";
  shell = args: spawn (noctaliaIPC ++ args);
in {
  nixpkgs.overlays = [
    outputs.overlays.umbriel
    outputs.overlays.noctalia
    outputs.overlays.helium
  ];

  imports = [
    ../../common
    inputs.umbriel.homeModules.default
    ./theme.nix
  ];

  programs.umbriel = {
    enable = true;
    package = pkgs.umbriel;
    settings = {
      general = {
        autostart = [
          "toggle-mute --init"
          "${pkgs.arrpc}/bin/arrpc"
          "${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"
          "QT_QPA_PLATFORM_THEME=qt6ct ${lib.getExe pkgs.noctalia} -d"
        ];
        xwayland = true;
        show_cheatsheet = false;
        focus_on_activate = true;
      };

      animation.duration_ms = 100;
      appearance = {
        border_width = 2;
        corner_radius = 0;

        shadow = {
          enabled = true;
          softness = 10;
          offset_x = 2;
          offset_y = 2;
          color = "#0000007F";
        };

        blur = {
          enabled = true;
          optimized = false;
          passes = 3;
          radius = 3;
          noise = 0.05;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.2;
        };
      };

      overview = {
        zoom = 0.6;
      };

      hot_corners.top_left = {
        enabled = true;
        delay_ms = 10;
        action = "overview-open";
      };

      layout = {
        mode = "scrolling";
        gap = 0;
        width_presets = [0.333 0.5 0.667];

        scrolling = {
          default_width_fraction = 1.0;
          center_underfull_strip = true;
        };
      };

      input =
        {
          middle_click_paste = true;

          mouse = {
            accel_profile = "flat";
            sensitivity = 0.0;
            scroll_wheel_step = 60;
          };

          tablet = {
            enabled = true;
          };

          cursor = {
            theme = "";
            hardware_cursor = true;
            hide_when_typing = true;
            hide_timeout_ms = 0;
          };

          focus = {
            follows_mouse = true;
          };
        }
        // lib.optionalAttrs config.cfg.host.laptop {
          touchpad = {
            tap = true;
            natural_scroll = true;
          };
        };

      output =
        lib.mapAttrs (
          name: display:
            {
              inherit (display) scale;
              enabled = true;
            }
            // lib.optionalAttrs (display.resolution != null) {
              mode =
                "${toString display.resolution.width}x${toString display.resolution.height}"
                + lib.optionalString (display.refreshRate != null) "@${toString display.refreshRate}";
            }
            // lib.optionalAttrs (display.position != null) {
              position = [display.position.x display.position.y];
            }
            // lib.optionalAttrs display.variable-refresh-rate {
              vrr = "fullscreen";
            }
        )
        displays;

      keybinds = with config.commandsList; (
        lib.optionalAttrs config.cfg.host.bluetooth {
          "Mod+B" = shell ["panel-toggle" "control-center" "bluetooth"];
        }
        // {
          "Mod+T" = spawn terminal;
          "Mod+W" = spawn browser;
          "Mod+E" = spawn fileManager;
          "Mod+M" = spawn sysmon;
          "Mod+S" = spawn ["spotify"];
          "Mod+N" = shell ["panel-toggle" "control-center" "notifications"];
          "Mod" = shell ["panel-toggle" "launcher"];
          "Mod+V" = shell ["panel-toggle" "clipboard"];
          "Mod+A" = shell ["panel-toggle" "control-center"];
          "Mod+Shift+V" = shell ["panel-toggle" "control-center" "audio"];
          "Mod+Shift+W" = shell ["wallpaper-random"];
          "Mod+Shift+Q" = shell ["panel-toggle" "session"];
          "Mod+L" = shell ["session" "lock"];
          "Mod+F1" = shell ["panel-toggle" "kenn/keybind-cheatsheet:cheatsheet"];

          "Alt+Tab" = shell ["window-switcher"];
          "Mod+Tab" = "overview-toggle";
          "Mod+Q" = "window-close";
          "Mod+D" = "window-toggle-maximize";
          "Mod+Shift+D" = "window-toggle-maximize-to-edges";
          "Mod+F" = "window-toggle-fullscreen";
          "Mod+Shift+F" = "window-toggle-floating";
          "Mod+P" = "window-toggle-pinned";
          "Mod+C" = "window-center";
          "Mod+Shift+C" = "window-cycle-width";
          "Mod+Minus" = "window-modify-width:-0.1";
          "Mod+Equal" = "window-modify-width:0.1";

          "Mod+Shift+Space" = "window-move-to-scratchpad";
          "Mod+Space" = "scratchpad-toggle";
          "Mod+Ctrl+Space" = "window-restore-from-scratchpad";

          "Mod+Left" = "window-focus-left";
          "Mod+Right" = "window-focus-right";
          "Mod+Up" = "window-focus-up";
          "Mod+Down" = "window-focus-down";

          "Mod+Shift+H" = "column-move-left";
          "Mod+Shift+L" = "column-move-right";
          "Mod+Shift+K" = "window-move-up";
          "Mod+Shift+J" = "window-move-down";

          "Mod+BracketLeft" = "window-consume-or-expel-left";
          "Mod+BracketRight" = "window-consume-or-expel-right";

          "Mod+Page_Up" = "workspace-previous";
          "Mod+Page_Down" = "workspace-next";

          "Mod+Alt+Left" = "output-focus-left";
          "Mod+Alt+Right" = "output-focus-right";
          "Mod+Alt+Shift+Left" = "column-move-to-output-left";
          "Mod+Alt+Shift+Right" = "column-move-to-output-right";

          "Mod+1" = "workspace-switch:1";
          "Mod+2" = "workspace-switch:2";
          "Mod+3" = "workspace-switch:3";
          "Mod+4" = "workspace-switch:4";
          "Mod+5" = "workspace-switch:5";
          "Mod+6" = "workspace-switch:6";
          "Mod+7" = "workspace-switch:7";
          "Mod+8" = "workspace-switch:8";
          "Mod+9" = "workspace-switch:9";

          "Mod+Shift+1" = "window-move-to-workspace:1";
          "Mod+Shift+2" = "window-move-to-workspace:2";
          "Mod+Shift+3" = "window-move-to-workspace:3";
          "Mod+Shift+4" = "window-move-to-workspace:4";
          "Mod+Shift+5" = "window-move-to-workspace:5";
          "Mod+Shift+6" = "window-move-to-workspace:6";
          "Mod+Shift+7" = "window-move-to-workspace:7";
          "Mod+Shift+8" = "window-move-to-workspace:8";
          "Mod+Shift+9" = "window-move-to-workspace:9";

          "Mod+Print" = shell ["screenshot-region"];
          "Print" = shell ["screenshot-fullscreen"];

          "Ctrl+Alt+Delete" = "session-quit";

          "Mod+Shift+B" = shell ["media" "previous"];
          "Mod+Shift+P" = shell ["media" "playPause"];
          "Mod+Shift+N" = shell ["media" "next"];
          "XF86AudioPlay" = shell ["media" "toggle"];
          "XF86AudioPause" = shell ["media" "toggle"];
          "XF86AudioNext" = shell ["media" "next"];
          "XF86AudioPrev" = shell ["media" "previous"];

          "XF86AudioRaiseVolume" = shell ["volume-up"];
          "XF86AudioLowerVolume" = shell ["volume-down"];
          "XF86AudioMute" = shell ["volume-mute"];
          "XF86AudioMicMute" = shell ["mic-mute"];
          "Shift+XF86AudioMute" = shell ["mic-mute"];
          "Shift+XF86AudioRaiseVolume" = shell ["mic-volume-up"];
          "Shift+XF86AudioLowerVolume" = shell ["mic-volume-down"];

          "XF86MonBrightnessUp" = shell ["brightness-up"];
          "XF86MonBrightnessDown" = shell ["brightness-down"];
        }
      );

      window_rule =
        [
          {
            match = {app_id = "^dev.noctalia.Noctalia$";};
            default_floating = true;
            default_size = [1020 900];
          }
          {
            match = {app_id = "^dev.noctalia.UmbrielSharePicker$";};
            default_floating = true;
            default_size = [800 600];
          }
          {
            match = {app_id = "^[S|s]potify$";};
            default_floating = true;
          }
          {
            match = {app_id = "^org\\.gnome\\.Nautilus$";};
            default_floating = true;
          }
          {
            match = {app_id = "^org\\.gnome\\.FileRoller$";};
            default_floating = true;
          }
          {
            match = {app_id = "^org\\.pulseaudio\\.pavucontrol$";};
            default_floating = true;
          }
          {
            match = {app_id = "^nm-connection-editor$";};
            default_floating = true;
          }
          {
            match.is_focused = true;
            opacity = 0.8;
          }
          {
            match.is_focused = false;
            opacity = 0.7;
          }
          {
            blur = true;
            blur_ignore_alpha = 0.1;
            blur_optimized = false;
          }
        ]
        ++ map (appid: {
          match = {app_id = "^${appid}$";};
          opacity = 1.0;
        }) [
          "helium"
          "com\.obsproject\.Studio"
          "org\.remmina\.Remmina"
          "firefox-devedition"
          "signal"
          "chromium-browser"
          "libreoffice-.*"
          "org\.kde\.okular"
          "org\.gnome\.Loupe"
          "org\.wireshark\.Wireshark"
          "com\.github\.johnfactotum\.Foliate"
          "Tor Browser"
          "org\.gnome\.Boxes"
          "vlc"
          "com\.github\.xournalpp\.xournalpp"
        ];

      layer_rule = [
        {
          match = {namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";};
          blur = true;
          blur_ignore_alpha = 0.1;
          blur_optimized = false;
        }
      ];
    };
  };
}
