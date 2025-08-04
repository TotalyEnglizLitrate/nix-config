{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  wallpapers = "/home/${userConfig.name}/Pictures/wallpapers";
in {
  imports = [
    ./cliphist.nix
    ./foot.nix
    ./gtk.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./kanshi.nix
    ./swappy.nix
    ./swaync.nix
    ./walker.nix
    ./waybar.nix
  ];

  # Consistent cursor theme across all applications.
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

  home.file.".config/niri/config.kdl" = ''
    input {
        keyboard {
            numlock true
        }

        touchpad {
            tap true
            natural-scroll true
        }

        mouse {
            natural-scroll true
        }

        warp-mouse-to-focus enable=true
    }

    cursor {
        theme "Bibata-Modern-Classic"
    }

    layout {
        gaps 0
        center-focused-column "on-overflow"

        default-column-width {
            proportion 0.5
        }

        focus-ring {
            width 4
            active color="#7aa2f7"
            inactive color="#505050"
        }

        struts {
            left 16
            right 16
            top 0
            bottom 4
        }
    }

    spawn-at-startup {
        - command="waybar"
        - command="xwayland-satellite"
        - command="sh" "-c" "pidof waybar || waybar"
        - command="swww-daemon"
        - command="swww" "restore"
        - command="walker" "--gapplication-service"
        - command="swaync"
        - command="${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"
        - command="kdeconnect-indicator"
        - command="nm-applet"
        - command="hypridle"
        - command="${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        - command="arrpc"
    }

    prefer-no-csd true
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    window-rule {
        match app-id="zen-browser$" title="^Picture-in-Picture$"
        open-floating true
    }

    window-rule {
        geometry-corner-radius {
            bottom-left 12.0
            bottom-right 12.0
            top-left 12.0
            top-right 12.0
        }
        clip-to-geometry true
        draw-border-with-background false
    }

    bind "Mod+Shift+W" action="show-hotkey-overlay"
    bind "Mod+T" action="spawn" command="foot shell"
    bind "Mod+R" action="spawn" command="walker"
    bind "Mod+W" action="spawn" command="zen"
    bind "Mod+B" action="spawn" command="blueman-manager"
    bind "Mod+E" action="spawn" command="nautilus"
    bind "Mod+M" action="spawn" command="foot" "-T" "btop" "btop"
    bind "Mod+N" action="spawn" command="swaync-client" "-t"
    bind "Mod+S" action="spawn" command="spotify" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"
    bind "Mod+V" action="spawn" command="foot" "-T" "clipboard" "cliphist-fzf"
    bind "Mod+Shift+V" action="spawn" command="cliphist" "wipe"
    bind "Mod+Shift+W" action="spawn" command="sh" "-c" "swww img '${wallpapers}/$(ls ${wallpapers} | shuf -n 1)' --transition-type none"

    bind "Mod+O" action="toggle-overview" repeat=false
    bind "Mod+Q" action="close-window"

    // Focus bindings
    bind "Mod+H" action="focus-column-or-monitor-left"
    bind "Mod+J" action="focus-window-or-workspace-down"
    bind "Mod+K" action="focus-window-or-workspace-up"
    bind "Mod+L" action="focus-column-or-monitor-right"
    bind "Mod+Shift+H" action="focus-monitor-left"
    bind "Mod+Shift+L" action="focus-monitor-right"

    // Move bindings
    bind "Mod+Ctrl+H" action="move-column-left-or-to-monitor-left"
    bind "Mod+Ctrl+J" action="move-window-down-or-to-workspace-down"
    bind "Mod+Ctrl+K" action="move-window-up-or-to-workspace-up"
    bind "Mod+Ctrl+L" action="move-column-right-or-to-monitor-right"
    bind "Mod+Ctrl+Shift+H" action="move-column-to-monitor-left"
    bind "Mod+Ctrl+Shift+L" action="move-column-to-monitor-right"

    // Column navigation
    bind "Mod+Home" action="focus-column-first"
    bind "Mod+End" action="focus-column-last"
    bind "Mod+Ctrl+Home" action="move-column-to-first"
    bind "Mod+Ctrl+End" action="move-column-to-last"

    // Workspace navigation
    bind "Mod+Page_Down" action="focus-workspace-down"
    bind "Mod+Page_Up" action="focus-workspace-up"
    bind "Mod+Ctrl+Page_Down" action="move-column-to-workspace-down"
    bind "Mod+Ctrl+Page_Up" action="move-column-to-workspace-up"

    bind "Mod+Shift+Page_Down" action="move-workspace-down"
    bind "Mod+Shift+Page_Up" action="move-workspace-up"

    // Mouse wheel bindings
    bind "Mod+WheelScrollDown" action="focus-workspace-down" cooldown-ms=150
    bind "Mod+WheelScrollUp" action="focus-workspace-up" cooldown-ms=150
    bind "Mod+Ctrl+WheelScrollDown" action="move-column-to-workspace-down" cooldown-ms=150
    bind "Mod+Ctrl+WheelScrollUp" action="move-column-to-workspace-up" cooldown-ms=150

    bind "Mod+WheelScrollRight" action="focus-column-right"
    bind "Mod+WheelScrollLeft" action="focus-column-left"
    bind "Mod+Ctrl+WheelScrollRight" action="move-column-right"
    bind "Mod+Ctrl+WheelScrollLeft" action="move-column-left"

    bind "Mod+Shift+WheelScrollDown" action="focus-column-right"
    bind "Mod+Shift+WheelScrollUp" action="focus-column-left"
    bind "Mod+Ctrl+Shift+WheelScrollDown" action="move-column-right"
    bind "Mod+Ctrl+Shift+WheelScrollUp" action="move-column-left"

    // Workspace numbers
    bind "Mod+1" action="focus-workspace" workspace=1
    bind "Mod+2" action="focus-workspace" workspace=2
    bind "Mod+3" action="focus-workspace" workspace=3
    bind "Mod+4" action="focus-workspace" workspace=4
    bind "Mod+5" action="focus-workspace" workspace=5
    bind "Mod+6" action="focus-workspace" workspace=6
    bind "Mod+7" action="focus-workspace" workspace=7
    bind "Mod+8" action="focus-workspace" workspace=8
    bind "Mod+9" action="focus-workspace" workspace=9

    bind "Mod+Ctrl+1" action="move-column-to-workspace" workspace=1
    bind "Mod+Ctrl+2" action="move-column-to-workspace" workspace=2
    bind "Mod+Ctrl+3" action="move-column-to-workspace" workspace=3
    bind "Mod+Ctrl+4" action="move-column-to-workspace" workspace=4
    bind "Mod+Ctrl+5" action="move-column-to-workspace" workspace=5
    bind "Mod+Ctrl+6" action="move-column-to-workspace" workspace=6
    bind "Mod+Ctrl+7" action="move-column-to-workspace" workspace=7
    bind "Mod+Ctrl+8" action="move-column-to-workspace" workspace=8
    bind "Mod+Ctrl+9" action="move-column-to-workspace" workspace=9

    // Window management
    bind "Mod+BracketLeft" action="consume-or-expel-window-left"
    bind "Mod+BracketRight" action="consume-or-expel-window-right"

    bind "Mod+Comma" action="consume-window-into-column"
    bind "Mod+Period" action="expel-window-from-column"

    bind "Mod+S" action="switch-preset-column-width"
    bind "Mod+D" action="maximize-column"
    bind "Mod+F" action="fullscreen-window"
    bind "Mod+Ctrl+F" action="expand-column-to-available-width"

    bind "Mod+C" action="center-column"
    bind "Mod+Shift+C" action="spawn" command="hyprpicker"
    bind "Mod+Ctrl+C" action="center-visible-columns"

    bind "Mod+Minus" action="set-column-width" width="-10%"
    bind "Mod+Equal" action="set-column-width" width="+10%"

    bind "Mod+Shift+Minus" action="set-window-height" height="-10%"
    bind "Mod+Shift+Equal" action="set-window-height" height="+10%"

    bind "Mod+Shift+F" action="toggle-window-floating"

    bind "Mod+W" action="toggle-column-tabbed-display"
    bind "Mod+Print" action="screenshot"
    bind "Print" action="screenshot-screen"
    bind "Alt+Print" action="screenshot-window"

    bind "Mod+Escape" action="toggle-keyboard-shortcuts-inhibit" allow-inhibiting=false
    bind "Mod+Shift+Q" action="quit"
    bind "Ctrl+Alt+Delete" action="quit"

    bind "Mod+L" action="spawn" command="hyprlock"

    bind "Mod+Shift+B" action="spawn" command="playerctl" "previous"
    bind "Mod+Shift+P" action="spawn" command="playerctl" "play-pause"
    bind "Mod+Shift+N" action="spawn" command="playerctl" "next"
    bind "Mod+Shift+T" action="spawn" command="foot"
  '';
}
