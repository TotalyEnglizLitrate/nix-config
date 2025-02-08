{
  inputs,
  pkgs,
  lib,
  ...
}: let
  wallpaper = ./../../files/wallpapers/nix-logo.png;
in {
  imports = [
    ./cliphist.nix
    ./gtk.nix
    ./kanshi.nix
    ./swappy.nix
    ./swaync.nix
    ./waybar.nix
    ./wofi.nix
    ./xdg.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];
    settings = {
      # General
      exec-once = [
        "hyprpaper"
        "waybar"
        "hypridle"
        "gnome-keyring-daemon --start --components=secrets"
        "nm-applet --indicator"
        "swaync"
        "ulauncher --hide-window"
        "wl-paste --watch cliphist store"
        "arrpc"
        "warp-cli connect"
      ];

      monitor = ", 1600x900, auto, 1";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
        sensitivity = 0.2;
        accel_profile = "flat";
      };

      general = {
        allow_tearing = false;
        border_size = 1;
        "col.active_border" = "rgb(b7bdf8)";
        gaps_in = 3;
        gaps_out = 3;
        layout = "master";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = false;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = false;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = "yes, please :)";
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, easeInOutCubic"
          "specialWorkspace, 1, 1.94, easeInOutCubic, slidevert"
        ];
      };

      dwindle = {
        pseudotile = false;
        preserve_split = true;
      };

      master.new_status = "master";

      gestures.workspace_swipe = true;

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # Window rules
      windowrule = [
        "center 1, ^(.blueman-manager-wrapped)$"
        "center 1, ^(gnome-calculator|org\\.gnome\\.Calculator)$"
        "center 1, ^(nm-connection-editor)$"
        "center 1, ^(org.pulseaudio.pavucontrol)$"
        "float, ^(.blueman-manager-wrapped)$"
        "float, ^(gnome-calculator|org\\.gnome\\.Calculator)$"
        "float, ^(nm-connection-editor)$"
        "float, ^(org.pulseaudio.pavucontrol)$"
        "float, ^(ulauncher)$"
        "noborder, ^(ulauncher)$"
        "stayfocused, ^(.blueman-manager-wrapped)$"
        "stayfocused, ^(gnome-calculator|org\\.gnome\\.Calculator)$"
        "stayfocused, ^(org.pulseaudio.pavucontrol)$"
        "stayfocused, ^(swappy)$"
        "stayfocused, ^(ulauncher)$"
        "size 590 420, ^(.blueman-manager-wrapped)$"
        "size 590 420, ^(nm-connection-editor)$"
        "size 590 420, ^(org.pulseaudio.pavucontrol)$"
        "suppressevent maximize, class:.*"
      ];

      windowrulev2 = [
        "float, class:org.gnome.Nautilus"
        "float, class:xdg-desktop-portal-gtk"
        "size 990 580, class:org.gnome.Nautilus"
        "size 990 580, class:xdg-desktop-portal-gtk"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      xwayland.force_zero_scaling = true;

      plugin.hyprexpo = {
        columns = 3;
        gap_size = 5;
        bg_col = "rgb(111111)";
        workspace_method = "center current";
        enable_gesture = true;
        gesture_fingers = 3;
        gesture_distance = 300;
        gesture_positive = true;
      };

      # Keybindings
      bind = [
        "SUPER, TAB, hyprexpo:toggle"
        "SUPER, SUPER_L, exec, ulauncher-toggle"
        "SUPER, T, exec, alacritty"
        "SUPER, W, exec, zen-browser"
        "SUPER, E, exec, nautilus"
        "CTRL ALT, P, exec, gnome-pomodoro --start-stop"
        "SUPER, B, exec, blueman-manager"
        "SUPER, Q, killactive"
        "SUPER SHIFT, Q, exit"
        "SUPER ALT, SPACE, togglefloating"
        "SUPER, F, fullscreen, 0"
        "SUPER, D, fullscreen, 1"
        "SUPER, R, exec, wofi --show drun --allow-images"
        "SUPER, V, exec, cliphist list | wofi --show dmenu | cliphist decode | wl-copy"
        "SUPER SHIFT, V, exec, cliphist wipe"
        ", PRINT, exec,  grim -g \"$(slurp)\" - | swappy -f -"
        "SUPER, PRINT, exec, grim - | swappy -f -"
        "SUPER, P, exec, grim - | swappy -f -"
        "SUPER SHIFT, R, exec, $HOME/.local/bin/screen-recorder"
        "SUPER CTRL, T, exec, $HOME/.local/bin/ocr"
        "SUPER CTRL, V, exec, pavucontrol"
        "SUPER, L, exec, hyprlock"
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        "SUPER, N, exec, swaync-client -t -sw"
        ", XF86AudioRaiseVolume, exec, pamixer --increase 10"
        ", XF86AudioLowerVolume, exec, pamixer --decrease 10"
        ", XF86AudioMute, exec, pamixer --toggle-mute"
        ", XF86AudioMicMute, exec, pamixer --default-source --toggle-mute"
        "SHIFT, XF86AudioRaiseVolume, exec, pamixer --increase 10 --default-source"
        "SHIFT, XF86AudioLowerVolume, exec, pamixer --decrease 10 --default-source"
        "SHIFT, XF86MonBrightnessUp, exec, brightnessctl -d tpacpi::kbd_backlight set +33%"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl -d tpacpi::kbd_backlight set 33%-"

        "SUPER SHIFT, left, resizeactive, -50 0"
        "SUPER SHIFT, right, resizeactive, 50 0"
        "SUPER SHIFT, up, resizeactive, 0 -50"
        "SUPER SHIFT, down, resizeactive, 0 50"

        # Switch workspaces with mainMod + [0-9]
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Move active window to a workspace silently with mainMod + ALT + [0-9]
        "SUPER ALT, 1, movetoworkspacesilent, 1"
        "SUPER ALT, 2, movetoworkspacesilent, 2"
        "SUPER ALT, 3, movetoworkspacesilent, 3"
        "SUPER ALT, 4, movetoworkspacesilent, 4"
        "SUPER ALT, 5, movetoworkspacesilent, 5"
        "SUPER ALT, 6, movetoworkspacesilent, 6"
        "SUPER ALT, 7, movetoworkspacesilent, 7"
        "SUPER ALT, 8, movetoworkspacesilent, 8"
        "SUPER ALT, 9, movetoworkspacesilent, 9"
        "SUPER ALT, 0, movetoworkspacesilent, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"

        # Move through workspaces with Meta + PgUp/PgDn
        "SUPER, Page_Up, workspace, m-1"
        "SUPER, Page_Down, workspace, m+1"

        # Cycle through windows in a workspace
        "ALT, TAB, cyclenext"
        "SHIFT ALT, TAB, cyclenext, prev"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER, X, movewindow"
        "SUPER, Z, resizewindow"
      ];

      bindl = [
        "SUPER SHIFT, N, exec, playerctl next"
        "SUPER SHIFT, P, exec, playerctl play-pause"
        "SUPER SHIFT, B, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  # Consistent cursor theme across all applications.
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.yaru-theme;
    name = "Yaru";
    size = 24;
  };

  # Source hyprland config from the home-manager store
  xdg.configFile = {
    "hypr/hyprpaper.conf".text = ''
      splash = false
      preload = ${wallpaper}
      wallpaper = DP-1, ${wallpaper}
      wallpaper = eDP-1, ${wallpaper}
    '';

    "hypr/hypridle.conf".text = ''
      general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
      }
    '';

    "hypr/hyprlock.conf".text = ''
      background {
          monitor =
          path = ${wallpaper}
          blur_passes = 1
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
      }

      general {
          no_fade_in = false
          grace = 0
          disable_loading_bar = true
      }

      # eDP-1 Conifg
      input-field {
          monitor = eDP-1
          size = 250, 60
          outline_thickness = 2
          dots_size = 0.2
          dots_center = true
          outer_color = rgba(0, 0, 0, 0)
          inner_color = rgba(0, 0, 0, 0.5)
          font_color = rgb(200, 200, 200)
          fade_on_empty = false
          capslock_color = -1
          placeholder_text = <i><span foreground="##e6e9ef">Password</span></i>
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
          hide_input = false
          position = 0, -120
          halign = center
          valign = center
      }

      # Date
      label {
        monitor = eDP-1
        text = cmd[update:1000] echo "<span>$(date '+%A, %d %B')</span>"
        color = rgba(255, 255, 255, 0.8)
        font_size = 30
        font_family = JetBrains Mono Nerd Font Mono ExtraBold
        halign = center
        valign = center
      }

      # Time
      label {
          monitor = eDP-1
          text = cmd[update:1000] echo "<span>$(date '+%H:%M:%S')</span>"
          color = rgba(255, 255, 255, 0.8)
          font_size = 70
          position = 0, 120
          font_family = JetBrains Mono Nerd Font Mono ExtraBold
          halign = center
          valign = center
      }
    '';
  };

  dconf.settings = {
    "org/blueman/general" = {
      "plugin-list" = lib.mkForce ["!StatusNotifierItem"];
    };

    "org/blueman/plugins/powermanager" = {
      "auto-power-on" = true;
    };

    "org/gnome/calculator" = {
      "accuracy" = 9;
      "angle-units" = "degrees";
      "base" = 10;
      "button-mode" = "basic";
      "number-format" = "automatic";
      "show-thousands" = false;
      "show-zeroes" = false;
      "source-currency" = "";
      "source-units" = "degree";
      "target-currency" = "";
      "target-units" = "radian";
      "window-maximized" = false;
    };

    "org/gnome/nautilus/preferences" = {
      "default-folder-viewer" = "grid-view";
      "migrated-gtk-settings" = true;
      "search-filter-time-type" = "last_modified";
      "search-view" = "list-view";
    };

    "org/gnome/nm-applet" = {
      "disable-connected-notifications" = true;
      "disable-vpn-notifications" = true;
    };

    "org/gtk/settings/file-chooser" = {
      "date-format" = "regular";
      "location-mode" = "path-bar";
      "show-size-column" = true;
      "show-type-column" = true;
      "sort-column" = "name";
      "sort-directories-first" = false;
      "sort-order" = "ascending";
      "type-format" = "category";
      "view-type" = "grid";
    };
  };
}
