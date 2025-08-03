{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  wallpapers = "/home/${userConfig.name}/Pictures/wallpapers";
  screenshots = "/home/${userConfig.name}/Pictures/Screenshots";
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

  input = {
    keyboard = {
      numlock = true;
    };

    touchpad = {
      tap = true;
      natural-scroll = true;
    };

    mouse = {
      natural-scroll = true;
    };

    warp-mouse-to-focus.enable = true;
  };
  cursor = {
    theme = "Bibata-Modern-Classic";
  };

  layout = {
    gaps = 0;
    center-focused-column = "on-overflow";
    default-column-width = {
      proportion = 0.5;
    };
    focus-ring = {
      width = 4;
      active.color = "#7aa2f7";
      inactive.color = "#505050";
    };
    struts = {
      left = 16;
      right = 16;
      top = 0;
      bottom = 4;
    };
  };

  spawn-at-startup = [
    {command = ["waybar"];}
    {command = ["xwayland-satellite"];}
    {command = ["sh" "-c" "pidof waybar || waybar"];}
    {command = ["swww-daemon"];}
    {command = ["swww" "restore"];}
    {command = ["walker" "--gapplication-service"];}
    {command = ["swaync"];}
    {command = ["${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"];}
    {command = ["kdeconnect-indicator"];}
    {command = ["nm-applet"];}
    {command = ["hypridle"];}
    {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
    {command = ["arrpc"];}
  ];

  prefer-no-csd = true;
  screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

  animations = {};

  window-rules = [
    {
      matches = [
        {
          app-id = "zen-browser$";
          title = "^Picture-in-Picture$";
        }
      ];
      open-floating = true;
    }
    {
      geometry-corner-radius = let
        radius = 12.0;
      in {
        bottom-left = radius;
        bottom-right = radius;
        top-left = radius;
        top-right = radius;
      };
      clip-to-geometry = true;
      draw-border-with-background = false;
    }
  ];

  binds = {
    "Mod+Shift+W".action.show-hotkey-overlay = {};
    "Mod+T".action.spawn = "foot shell";
    "Mod+R".action.spawn = "walker";
    "Mod+W".action.spawn = "zen";
    "Mod+B".action.spawn = "blueman-manager";
    "Mod+E".action.spawn = "nautilus";
    "Mod+M".action.spawn = ["foot" "-T" "btop" "btop"];
    "Mod+N".action.spawn = ["swaync-client" "-t"];
    "Mod+S".action.spawn = ["spotify" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"];
    "Mod+V".action.spawn = ["foot" "-T" "clipboard" "cliphist-fzf"];
    "Mod+Shift+V".action.spawn = ["cliphist" "wipe"];
    "Mod+Shift+W".action.spawn = ["sh" "-c" "swww img '${wallpapers}/$(ls ${wallpapers} | shuf -n 1)' --transition-type none"];

    "Mod+O" = {
      action.toggle-overview = {};
      repeat = false;
    };
    "Mod+Q".action.close-window = {};

    # Focus bindings
    "Mod+H".action.focus-column-or-monitor-left = {};
    "Mod+J".action.focus-window-or-workspace-down = {};
    "Mod+K".action.focus-window-or-workspace-up = {};
    "Mod+L".action.focus-column-or-monitor-right = {};
    "Mod+Shift+H".action.focus-monitor-left = {};
    "Mod+Shift+L".action.focus-monitor-right = {};

    # Move bindings
    "Mod+Ctrl+H".action.move-column-left-or-to-monitor-left = {};
    "Mod+Ctrl+J".action.move-window-down-or-to-workspace-down = {};
    "Mod+Ctrl+K".action.move-window-up-or-to-workspace-up = {};
    "Mod+Ctrl+L".action.move-column-right-or-to-monitor-right = {};
    "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = {};
    "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = {};

    # Column navigation
    "Mod+Home".action.focus-column-first = {};
    "Mod+End".action.focus-column-last = {};
    "Mod+Ctrl+Home".action.move-column-to-first = {};
    "Mod+Ctrl+End".action.move-column-to-last = {};

    # Workspace navigation
    "Mod+Page_Down".action.focus-workspace-down = {};
    "Mod+Page_Up".action.focus-workspace-up = {};
    "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
    "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};

    "Mod+Shift+Page_Down".action.move-workspace-down = {};
    "Mod+Shift+Page_Up".action.move-workspace-up = {};

    # Mouse wheel bindings
    "Mod+WheelScrollDown" = {
      action.focus-workspace-down = {};
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action.focus-workspace-up = {};
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action.move-column-to-workspace-down = {};
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action.move-column-to-workspace-up = {};
      cooldown-ms = 150;
    };

    "Mod+WheelScrollRight".action.focus-column-right = {};
    "Mod+WheelScrollLeft".action.focus-column-left = {};
    "Mod+Ctrl+WheelScrollRight".action.move-column-right = {};
    "Mod+Ctrl+WheelScrollLeft".action.move-column-left = {};

    "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
    "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
    "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
    "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

    # Workspace numbers
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

    # Window management
    "Mod+BracketLeft".action.consume-or-expel-window-left = {};
    "Mod+BracketRight".action.consume-or-expel-window-right = {};

    "Mod+Comma".action.consume-window-into-column = {};
    "Mod+Period".action.expel-window-from-column = {};

    "Mod+S".action.switch-preset-column-width = {};
    "Mod+D".action.maximize-column = {};
    "Mod+F".action.fullscreen-window = {};
    "Mod+Ctrl+F".action.expand-column-to-available-width = {};

    "Mod+C".action.center-column = {};
    "Mod+Shift+C".action.spawn = "hyprpicker";
    "Mod+Ctrl+C".action.center-visible-columns = {};

    "Mod+Minus".action.set-column-width = "-10%";
    "Mod+Equal".action.set-column-width = "+10%";

    "Mod+Shift+Minus".action.set-window-height = "-10%";
    "Mod+Shift+Equal".action.set-window-height = "+10%";

    "Mod+Shift+F".action.toggle-window-floating = {};

    "Mod+W".action.toggle-column-tabbed-display = {};
    "Mod+Print".action.screenshot = {};
    "Print".action.screenshot-screen = {};
    "Alt+Print".action.screenshot-window = {};

    "Mod+Escape" = {
      action.toggle-keyboard-shortcuts-inhibit = {};
      allow-inhibiting = false;
    };
    "Mod+Shift+Q".action.quit = {};
    "Ctrl+Alt+Delete".action.quit = {};

    "Mod+L".action.spawn = "hyprlock";

    "Mod+Shift+B".action.spawn = ["playerctl" "previous"];
    "Mod+Shift+P".action.spawn = ["playerctl" "play-pause"];
    "Mod+Shift+N".action.spawn = ["playerctl" "next"];
    "Mod+Shift+T".action.spawn = ["foot"];
  };

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
}
