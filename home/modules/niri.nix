{
  inputs,
  pkgs,
  lib,
  ...
}: {
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
    inputs.niri.homeModules.config
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

  programs.niri.config = ''
    input {
      touchpad {
        tap
        natural-scroll
      }

      warp-mouse-to-focus mode="center-xy"
      focus-follows-mouse max-scroll-amount="0%"
    }

    layout {
      gaps 1
      center-focused-column "on-overflow"

      default-column-width {
      proportion 0.5
      }

      focus-ring {
        off
      }

      struts {
        left 0
        right 0
        top 0
        bottom 0
      }
    }

    spawn-at-startup "waybar-restart"
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "wallpaper --init"
    spawn-at-startup "walker" "--gapplication-service"
    spawn-at-startup "swaync"
    spawn-at-startup "kdeconnect-indicator"
    spawn-at-startup "nm-applet"
    spawn-at-startup "hypridle"
    spawn-at-startup "arrpc"
    spawn-at-startup "systemctl" "--user" "restart" "kanshi.service"
    spawn-at-startup "${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    switch-events {
      lid-close { spawn "hyprlock"; }
    }
    window-rule {
      open-maximized true
    }

    window-rule {
      match app-id="zen-browser$" title="^Picture-in-Picture$"
      match app-id="zen-browser$" title="^Library$"
      match app-id="zen-browser$" title="^Extension.*$"
      match app-id="org.gnome.Nautilus"
      match app-id="org.gnome.FileRoller"
      match app-id="org.kde.polkit-kde-authentication-agent-1"
      match app-id=".blueman-manager-wrapped"
      match app-id="org.pulseaudio.pavucontrol"
      open-floating true
    }

    binds{
      Mod+T {spawn "foot" "shell";}
      Mod+R {spawn "walker";}
      Mod+W {spawn "zen";}
      Mod+B {spawn "blueman-manager";}
      Mod+E {spawn "nautilus";}
      Mod+M {spawn "foot" "-T" "btop" "btop";}
      Mod+N {spawn "swaync-client" "-t";}
      Mod+S {spawn "spotify" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland";}
      Mod+V {spawn "foot" "-T" "clipboard" "cliphist-fzf";}
      Mod+Shift+V {spawn "cliphist" "wipe";}
      Mod+Shift+W {spawn "wallpaper";}

      Mod+O repeat=false {toggle-overview;}
      Mod+Q {close-window;}

      Mod+left {focus-column-or-monitor-left;}
      Mod+down {focus-window-or-workspace-down;}
      Mod+up {focus-window-or-workspace-up;}
      Mod+right {focus-column-or-monitor-right;}

      Mod+Shift+H {move-column-left-or-to-monitor-left;}
      Mod+Shift+J {move-window-down-or-to-workspace-down;}
      Mod+Shift+K {move-window-up-or-to-workspace-up;}
      Mod+Shift+L {move-column-right-or-to-monitor-right;}

      Mod+Home {focus-column-first;}
      Mod+End {focus-column-last;}
      Mod+Ctrl+Home {move-column-to-first;}
      Mod+Ctrl+End {move-column-to-last;}

      Mod+Page_Down {focus-workspace-down;}
      Mod+Page_Up {focus-workspace-up;}
      Mod+Ctrl+Page_Down {move-column-to-workspace-down;}
      Mod+Ctrl+Page_Up {move-column-to-workspace-up;}

      Mod+Shift+Page_Down {move-workspace-down;}
      Mod+Shift+Page_Up {move-workspace-up;}

      Mod+WheelScrollDown cooldown-ms=150 {focus-workspace-down;}
      Mod+WheelScrollUp cooldown-ms=150 {focus-workspace-up;}
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 {move-column-to-workspace-down;}
      Mod+Ctrl+WheelScrollUp cooldown-ms=150 {move-column-to-workspace-up;}

      Mod+WheelScrollRight {focus-column-right;}
      Mod+WheelScrollLeft {focus-column-left;}
      Mod+Ctrl+WheelScrollRight {move-column-right;}
      Mod+Ctrl+WheelScrollLeft {move-column-left;}

      Mod+Shift+WheelScrollDown {focus-column-right;}
      Mod+Shift+WheelScrollUp {focus-column-left;}
      Mod+Ctrl+Shift+WheelScrollDown {move-column-right;}
      Mod+Ctrl+Shift+WheelScrollUp {move-column-left;}

      Mod+1 {focus-workspace 1;}
      Mod+2 {focus-workspace 2;}
      Mod+3 {focus-workspace 3;}
      Mod+4 {focus-workspace 4;}
      Mod+5 {focus-workspace 5;}
      Mod+6 {focus-workspace 6;}
      Mod+7 {focus-workspace 7;}
      Mod+8 {focus-workspace 8;}
      Mod+9 {focus-workspace 9;}

      Mod+Ctrl+1 {move-column-to-workspace 1;}
      Mod+Ctrl+2 {move-column-to-workspace 2;}
      Mod+Ctrl+3 {move-column-to-workspace 3;}
      Mod+Ctrl+4 {move-column-to-workspace 4;}
      Mod+Ctrl+5 {move-column-to-workspace 5;}
      Mod+Ctrl+6 {move-column-to-workspace 6;}
      Mod+Ctrl+7 {move-column-to-workspace 7;}
      Mod+Ctrl+8 {move-column-to-workspace 8;}
      Mod+Ctrl+9 {move-column-to-workspace 9;}

      Mod+BracketLeft {consume-or-expel-window-left;}
      Mod+BracketRight {consume-or-expel-window-right;}

      Mod+Comma {consume-window-into-column;}
      Mod+Period {expel-window-from-column;}

      Mod+D {maximize-column;}
      Mod+F {fullscreen-window;}
      Mod+Ctrl+F {expand-column-to-available-width;}

      Mod+C {center-column;}
      Mod+Shift+C {spawn "colorpicker";}
      Mod+Ctrl+T {spawn "ocr";}
      Mod+Ctrl+C {center-visible-columns;}

      Mod+Minus {set-column-width "-10%";}
      Mod+Equal {set-column-width "+10%";}

      Mod+Shift+Minus {set-window-height "-10%";}
      Mod+Shift+Equal {set-window-height "+10%";}

      Mod+Shift+F {toggle-window-floating;}

      Mod+Print {screenshot;}
      Print {screenshot-screen;}
      Alt+Print {screenshot-window;}

      Mod+Shift+Q {quit;}
      Ctrl+Alt+Delete {quit;}

      Mod+L {spawn "hyprlock";}

      Mod+Shift+B allow-when-locked=true {spawn "playerctl" "previous";}
      Mod+Shift+P allow-when-locked=true {spawn "playerctl" "play-pause";}
      Mod+Shift+N allow-when-locked=true {spawn "playerctl" "next";}
      Mod+Shift+T {spawn "foot";}

      XF86AudioPlay allow-when-locked=true {spawn "playerctl" "play-pause";}
      XF86AudioPause allow-when-locked=true {spawn "playerctl" "play-pause";}
      XF86AudioNext allow-when-locked=true {spawn "playerctl" "next";}
      XF86AudioPrev allow-when-locked=true {spawn "playerctl" "previous";}

      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }
    }'';
}
