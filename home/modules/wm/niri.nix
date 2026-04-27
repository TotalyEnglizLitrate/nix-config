{
  hostname,
  lib,
  pkgs,
  ...
}: let
  scale = {
    wanderer = 1;
    latitude5491 = 0.7;
    omnibook = 1;
  };
  bitwarden = {
    app-id = "chrome-nngceckbapebfimnlniiiahkandclblb.*";
    title = "_crx_nngceckbapebfimnlniiiahkandclblb";
  };
  noctalia_cmd = args: ["noctalia-shell" "ipc" "call"] ++ args;
in {
  imports = [
    ./foot.nix
    ./gtk.nix
    ./kanshi.nix
    ./packages.nix
    ./spotify.nix
    ./desktop-shell.nix
  ];

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  xdg.mimeApps.defaultApplications = lib.mkMerge [
    {
      "application/x-extension-htm" = "helium.desktop";
      "application/x-extension-html" = "helium.desktop";
      "application/x-extension-shtml" = "helium.desktop";
      "application/x-extension-xht" = "helium.desktop";
      "application/x-extension-xhtml" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
      "text/html" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/ftp" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "application/pdf" = "helium.desktop";
    }
  ];

  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "niri";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  dconf.settings = {
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
        scale = scale.${hostname};
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
      {command = ["sh" "-c" "QT_QPA_PLATFORMTHEME=gtk3 noctalia-shell -d"];}
      {command = ["toggle-mute" "--init"];}
      {command = ["xwayland-satellite"];}
      {command = ["kdeconnect-indicator"];}
      {command = ["arrpc"];}
      {command = ["${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"];}
      {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
    ];

    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    prefer-no-csd = true;
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    switch-events.lid-close.action.spawn = noctalia_cmd ["lockScreen" "lock"];

    window-rules = [
      {open-maximized = true;}

      {
        matches = [
          bitwarden
          {app-id = "Spotify";}
          {app-id = "org\.gnome\.Nautilus";}
          {app-id = "org\.gnome\.FileRoller";}
          {app-id = "org\.pulseaudio\.pavucontrol";}
          {app-id = "nm-connection-editor";}
        ];

        open-floating = true;
      }

      {
        matches = [
          bitwarden
          {app-id = "org\.gnome\.seahorse\.Application";}
        ];
        block-out-from = "screen-capture";
      }
    ];

    binds = {
      "Mod+T".action.spawn = ["foot"];
      "Mod+W".action.spawn = ["helium"];
      "Mod+E".action.spawn = ["nautilus"];
      "Mod+M".action.spawn = ["foot" "-T" "btop" "btop"];
      "Mod+N".action.spawn = noctalia_cmd ["notifications" "toggleHistory"];
      "Mod+S".action.spawn = ["spotify" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"];
      "Mod+P".action.spawn = ["niri" "msg" "action" "set-dynamic-cast-window"];
      "Mod+R".action.spawn = noctalia_cmd ["launcher" "toggle"];
      "Mod+V".action.spawn = noctalia_cmd ["launcher" "clipboard"];
      "Mod+B".action.spawn = noctalia_cmd ["bluetooth" "togglePanel"];
      "Mod+A".action.spawn = noctalia_cmd ["controlCenter" "toggle"];
      "Mod+Shift+V".action.spawn = noctalia_cmd ["volume" "togglePanel"];

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
      "Mod+Shift+C".action.spawn = noctalia_cmd ["plugin:screen-toolkit" "colorPicker"];
      "Mod+Ctrl+T".action.spawn = noctalia_cmd ["plugin:screen-toolkit" "ocr"];
      "Mod+Ctrl+C".action.center-visible-columns = {};

      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";

      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      "Mod+Shift+F".action.toggle-window-floating = {};

      "Mod+Print".action.screenshot = {};
      "Print".action.screenshot-screen = {};
      "Alt+Print".action.screenshot-window = {};

      "Mod+Shift+Q".action.quit = {skip-confirmation = true;};
      "Ctrl+Alt+Delete".action.quit = {};

      "Mod+L".action.spawn = noctalia_cmd ["lockScreen" "lock"];

      "Mod+Shift+B" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["media" "previous"];
      };
      "Mod+Shift+P" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["media" "playPause"];
      };
      "Mod+Shift+N" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["media" "next"];
      };

      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["media" "playPause"];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["media" "playPause"];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["media" "next"];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["media" "previous"];
      };

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["volume" "increase"];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["volume" "decrease"];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["volume" "muteOutput"];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["volume" "muteInput"];
      };
      "Shift+XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["volume" "muteInput"];
      };
      "Shift+XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["volume" "increaseInput"];
      };
      "Shift+XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["volume" "decreaseInput"];
      };

      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["brightness" "increase"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = noctalia_cmd ["brightness" "decrease"];
      };
    };
  };
}
