{
  hostname,
  inputs,
  pkgs,
  lib,
  ...
}: let
  PrtScr =
    if hostname == "omnibook"
    then "F12"
    else "Print";
in {
  imports = [
    ./cliphist.nix
    ./foot.nix
    ./gtk.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./swappy.nix
    ./swaync.nix
    ./walker.nix
    ./waybar.nix
    inputs.niri.homeModules.config
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  dconf.settings = {
    "org/blueman/general" = {
      "plugin-list" = lib.mkForce ["!StatusNotifierItem"];
    };

    "org/blueman/plugins/powermanager" = {
      "auto-power-on" = true;
    };

    "org/gnome/nautilus/preferences" = {
      "default-folder-viewer" = "grid-view";
      "migrated-gtk-settings" = true;
      "search-filter-time-type" = "last_modified";
      "search-view" = "list-view";
    };

    "org/gtk/settings/file-chooser" = {
      "date-format" = "regular";
      "location-mode" = "path-bar";
      "show-size-column" = true;
      "show-type-column" = true;
      "sort-column" = "name";
      "sort-directories-first" = true;
      "sort-order" = "ascending";
      "type-format" = "category";
      "view-type" = "grid";
    };
  };

  programs.niri.settings = {
    input = {
      touchpad = {
        tap = true;
        natural-scroll = true;
      };

      warp-mouse-to-focus = {
        enable = true;
        mode = "center-xy";
      };

      focus-follows-mouse.max-scroll-amount = "0%";
    };

    outputs = {
      eDP-1 = {
        enable = true;
        scale =
          if hostname == "wanderer"
          then 1
          else if hostname == "lattitude5491"
          then 0.7
          else if hostname == "omnibook"
          then 1.25
          else abort "Should be unreachable";
        variable-refresh-rate = hostname == "omnibook";
      };
    };

    layout = {
      gaps = 0;
      center-focused-column = "on-overflow";
      default-column-width.proportion = 0.5;
      focus-ring.enable = false;

      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
    };

    spawn-at-startup = [
      {command = ["wallpaper" "--init"];}
      {command = ["toggle-mute" "--init"];}
      {command = ["waybar-restart"];}
      {command = ["xwayland-satellite"];}
      {command = ["swaync"];}
      {command = ["kdeconnect-indicator"];}
      {command = ["hypridle"];}
      {command = ["arrpc"];}
      {command = ["${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"];}
      {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
      {command = ["pkill" "nm-applet"];}
    ];

    prefer-no-csd = true;
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    switch-events.lid-close.action.spawn = ["hyprlock"];

    window-rules = [
      {open-maximized = true;}

      {
        matches = [
          {
            app-id = "zen-browser$";
            title = "^(Picture-in-Picture|Library|Extension.*)$";
          }

          {app-id = "org.gnome.Nautilus";}
          {app-id = "org.gnome.FileRoller";}
          {app-id = "org.polkit-kde-authentication-agent-1";}
          {app-id = ".blueman-manager-wrapped";}
          {app-id = "org.pulseaudio.pavucontrol";}
          {app-id = "nm-connection-editor";}
          {app-id = ".protonvpn-app-wrapped";}

          {title = "clipboard";}
        ];

        open-floating = true;
      }
    ];

    binds = {
      "Mod+T".action.spawn = ["foot"];
      "Mod+R".action.spawn = ["nc" "-U" "/run/user/1000/walker/walker.sock"];
      "Mod+W".action.spawn = ["zen"];
      "Mod+B".action.spawn = ["blueman-manager"];
      "Mod+E".action.spawn = ["nautilus"];
      "Mod+M".action.spawn = ["foot" "-T" "btop" "btop"];
      "Mod+N".action.spawn = ["swaync-client" "-t"];
      "Mod+S".action.spawn = ["spotify" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"];
      "Mod+V".action.spawn = ["foot" "-T" "clipboard" "cliphist-fzf"];
      "Mod+Shift+V".action.spawn = ["cliphist" "wipe"];
      "Mod+Shift+W".action.spawn = ["wallpaper"];

      "Mod+Tab" = {
        repeat = false;
        action.toggle-overview = {};
      };
      "Mod+Q".action.close-window = {};

      "Mod+left".action.focus-column-or-monitor-left = {};
      "Mod+down".action.focus-window-or-workspace-down = {};
      "Mod+up".action.focus-window-or-workspace-up = {};
      "Mod+right".action.focus-column-or-monitor-right = {};

      "Mod+Shift+H".action.move-column-left-or-to-monitor-left = {};
      "Mod+Shift+J".action.move-window-down-or-to-workspace-down = {};
      "Mod+Shift+K".action.move-window-up-or-to-workspace-up = {};
      "Mod+Shift+L".action.move-column-right-or-to-monitor-right = {};

      "Mod+Home".action.focus-column-first = {};
      "Mod+End".action.focus-column-last = {};
      "Mod+Ctrl+Home".action.move-column-to-first = {};
      "Mod+Ctrl+End".action.move-column-to-last = {};

      "Mod+Page_Down".action.focus-workspace-down = {};
      "Mod+Page_Up".action.focus-workspace-up = {};
      "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};

      "Mod+Shift+Page_Down".action.move-workspace-down = {};
      "Mod+Shift+Page_Up".action.move-workspace-up = {};

      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action.focus-workspace-down = {};
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action.focus-workspace-up = {};
      };
      "Mod+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-down = {};
      };
      "Mod+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-up = {};
      };

      "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
      "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
      "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
      "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Ctrl+1".action.move-column-to-workspace = 1;
      "Mod+Ctrl+2".action.move-column-to-workspace = 2;
      "Mod+Ctrl+3".action.move-column-to-workspace = 3;
      "Mod+Ctrl+4".action.move-column-to-workspace = 4;
      "Mod+Ctrl+5".action.move-column-to-workspace = 5;
      "Mod+Ctrl+6".action.move-column-to-workspace = 6;
      "Mod+Ctrl+7".action.move-column-to-workspace = 7;
      "Mod+Ctrl+8".action.move-column-to-workspace = 8;
      "Mod+Ctrl+9".action.move-column-to-workspace = 9;

      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};

      "Mod+Comma".action.consume-window-into-column = {};
      "Mod+Period".action.expel-window-from-column = {};

      "Mod+D".action.maximize-column = {};
      "Mod+F".action.fullscreen-window = {};
      "Mod+Ctrl+F".action.expand-column-to-available-width = {};

      "Mod+C".action.center-column = {};
      "Mod+Shift+C".action.spawn = ["colorpicker"];
      "Mod+Ctrl+T".action.spawn = ["ocr"];
      "Mod+Ctrl+C".action.center-visible-columns = {};

      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";

      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      "Mod+Shift+F".action.toggle-window-floating = {};

      "Mod+${PrtScr}".action.screenshot = {};
      "${PrtScr}".action.screenshot-screen = {};
      "Alt+${PrtScr}".action.screenshot-window = {};

      "Mod+Shift+Q".action.quit = {skip-confirmation = true;};
      "Ctrl+Alt+Delete".action.quit = {};

      "Mod+L".action.spawn = ["hyprlock"];

      "Mod+Shift+B" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "previous"];
      };
      "Mod+Shift+P" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "play-pause"];
      };
      "Mod+Shift+N" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "next"];
      };

      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "play-pause"];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "play-pause"];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "next"];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "previous"];
      };

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = ["toggle-mute"];
      };
      "Shift+XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = ["sh" "-c" "echo ''> /var/run/mute-led-fixd.pipe"];
      };
      "Shift+XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SOURCE@" "5%+"];
      };
      "Shift+XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SOURCE@" "5%-"];
      };

      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["brightnessctl" "--class=backlight" "set" "+5%"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["brightnessctl" "--class=backlight" "set" "5%-"];
      };
    };
  };
}
