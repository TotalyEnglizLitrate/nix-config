{
  lib,
  outputs,
  config,
  osConfig,
  pkgs,
  ...
}: let
  noctalia = lib.getExe pkgs.noctalia;
  noctaliaIPC = [noctalia "msg"];
in {
  nixpkgs.overlays = [
    outputs.overlays.niri
    outputs.overlays.noctalia
    outputs.overlays.helium
  ];
  imports = [
    ./terminal.nix
    ./gtk.nix
    ./kanshi.nix
    ./packages.nix
    ./spotify.nix
    ./noctalia/home
    ./xdg.nix
  ];

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  home.sessionVariables = {
    EDITOR = config.commands.editor.binary;
    XDG_SESSION_DESKTOP = "niri";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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

  wayland.windowManager.niri.enable = true;
  wayland.windowManager.niri.package = pkgs.niri-unstable;
  wayland.windowManager.niri.settings = let
    shell = args: noctaliaIPC ++ args;

    displays = osConfig.cfg.host.displays;
  in
    {
      input =
        {
          warp-mouse-to-focus._props.mode = "center-xy";

          focus-follows-mouse._props.max-scroll-amount = "0%";
        }
        // lib.optionalAttrs osConfig.cfg.host.laptop {
          touchpad = {
            tap = [];
            natural-scroll = [];
            accel-speed = 0.4;
          };
        };

      layout = {
        gaps = 0;
        center-focused-column = "on-overflow";
        default-column-width.proportion = 0.5;
        focus-ring.width = 1;
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
      };

      spawn-sh-at-startup = [
        ["QT_QPA_PLATFORM_THEME=qt6ct ${noctalia} -d"]
      ];

      spawn-at-startup = [
        ["toggle-mute" "--init"]
        [(lib.getExe pkgs.xwayland-satellite-unstable)]
        [(lib.getExe pkgs.arrpc)]
        ["${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"]
        ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"]
      ];

      hotkey-overlay = {
        skip-at-startup = [];
        hide-not-bound = [];
      };

      prefer-no-csd = [];
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      debug.honor-xdg-activation-with-invalid-serial = [];

      window-rule = let
        match = props: {_props = props;};

        bitwarden = match {
          app-id = "chrome-nngceckbapebfimnlniiiahkandclblb.*";
          title = "_crx_nngceckbapebfimnlniiiahkandclblb";
        };
      in
        [
          {
            match = [
              (match {app-id = "[S|s]potify";})
              (match {app-id = "org\.gnome\.Nautilus";})
              (match {app-id = "org\.gnome\.FileRoller";})
              (match {app-id = "org\.pulseaudio\.pavucontrol";})
              (match {app-id = "nm-connection-editor";})
            ];

            open-floating = true;

            default-column-width.proportion = 0.4;
            default-window-height.proportion = 0.45;
          }

          {
            match = [
              (match {app-id = "dev\.noctalia\.Noctalia";})
            ];

            open-floating = true;

            default-column-width.proportion = 0.56;
            default-window-height.proportion = 0.85;
          }

          {
            match = [
              bitwarden
              (match {app-id = "org\.kde\.kdeconnect\..*";})
            ];

            open-floating = true;
            default-column-width.proportion = 0.3;
            default-window-height.proportion = 0.5;
          }

          {
            match = [
              bitwarden
              (match {app-id = "org\.gnome\.seahorse\.Application";})
            ];
            block-out-from = "screen-capture";
          }
        ]
        ++ [
          (
            if osConfig.cfg.host.laptop
            then {open-maximized = true;}
            else {
              default-column-width.proportion = 0.5;
              default-window-height.proportion = 1.0;
            }
          )
        ];

      binds = with osConfig.cfg;
      with config.commandsList;
        lib.optionalAttrs host.bluetooth {
          "Mod+B".spawn = shell ["panel-toggle" "control-center" "bluetooth"];
        }
        // {
          "Mod+T".spawn = terminal;
          "Mod+W".spawn = browser;
          "Mod+E".spawn = fileManager;
          "Mod+M".spawn = sysmon;
          "Mod+N".spawn = shell ["panel-toggle" "control-center" "notifications"];
          "Mod+S".spawn = ["spotify"];
          "Mod+R".spawn = shell ["panel-toggle" "launcher"];
          "Mod+V".spawn = shell ["panel-toggle" "clipboard"];
          "Mod+A".spawn = shell ["panel-toggle" "control-center"];
          "Mod+Shift+V".spawn = shell ["panel-toggle" "control-center" "audio"];
          "Mod+Shift+W".spawn = shell ["wallpaper-random"];

          "Mod+Tab" = {
            _props.repeat = false;
            toggle-overview = [];
          };

          "Mod+Q".close-window = [];
          "Mod+P".set-dynamic-cast-window = [];

          "Mod+left".focus-column-or-monitor-left = [];
          "Mod+down".focus-window-or-workspace-down = [];
          "Mod+up".focus-window-or-workspace-up = [];
          "Mod+right".focus-column-or-monitor-right = [];

          "Mod+Shift+H".move-column-left-or-to-monitor-left = [];
          "Mod+Shift+J".move-window-down-or-to-workspace-down = [];
          "Mod+Shift+K".move-window-up-or-to-workspace-up = [];
          "Mod+Shift+L".move-column-right-or-to-monitor-right = [];

          "Mod+Home".focus-column-first = [];
          "Mod+End".focus-column-last = [];
          "Mod+Ctrl+Home".move-column-to-first = [];
          "Mod+Ctrl+End".move-column-to-last = [];

          "Mod+Page_Down".focus-workspace-down = [];
          "Mod+Page_Up".focus-workspace-up = [];
          "Mod+Ctrl+Page_Down".move-column-to-workspace-down = [];
          "Mod+Ctrl+Page_Up".move-column-to-workspace-up = [];

          "Mod+Shift+Page_Down".move-workspace-down = [];
          "Mod+Shift+Page_Up".move-workspace-up = [];

          "Mod+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            focus-workspace-down = [];
          };
          "Mod+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            focus-workspace-up = [];
          };
          "Mod+Ctrl+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-down = [];
          };
          "Mod+Ctrl+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-up = [];
          };

          "Mod+Shift+WheelScrollDown".focus-column-right = [];
          "Mod+Shift+WheelScrollUp".focus-column-left = [];
          "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = [];
          "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = [];

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Ctrl+1".move-column-to-workspace = 1;
          "Mod+Ctrl+2".move-column-to-workspace = 2;
          "Mod+Ctrl+3".move-column-to-workspace = 3;
          "Mod+Ctrl+4".move-column-to-workspace = 4;
          "Mod+Ctrl+5".move-column-to-workspace = 5;
          "Mod+Ctrl+6".move-column-to-workspace = 6;
          "Mod+Ctrl+7".move-column-to-workspace = 7;
          "Mod+Ctrl+8".move-column-to-workspace = 8;
          "Mod+Ctrl+9".move-column-to-workspace = 9;

          "Mod+BracketLeft".consume-or-expel-window-left = [];
          "Mod+BracketRight".consume-or-expel-window-right = [];

          "Mod+Comma".consume-window-into-column = [];
          "Mod+Period".expel-window-from-column = [];

          "Mod+D".maximize-column = [];
          "Mod+F".fullscreen-window = [];

          "Mod+Ctrl+F".expand-column-to-available-width = [];
          "Mod+C".center-column = [];
          "Mod+Ctrl+C".center-visible-columns = [];

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";

          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+Shift+F".toggle-window-floating = [];

          "Mod+Print".screenshot = [];
          "Print".screenshot-screen = [];
          "Alt+Print".screenshot-window = [];

          "Mod+Shift+Q".spawn = shell ["panel-toggle" "session"];
          "Ctrl+Alt+Delete".quit = [];

          "Mod+L".spawn = shell [
            "session"
            "lock"
          ];

          "Mod+Shift+B" = {
            _props.allow-when-locked = true;
            spawn = shell [
              "media"
              "previous"
            ];
          };
          "Mod+Shift+P" = {
            _props.allow-when-locked = true;
            spawn = shell [
              "media"
              "playPause"
            ];
          };
          "Mod+Shift+N" = {
            _props.allow-when-locked = true;
            spawn = shell [
              "media"
              "next"
            ];
          };
          "XF86AudioPlay" = {
            _props.allow-when-locked = true;
            spawn = shell [
              "media"
              "toggle"
            ];
          };
          "XF86AudioPause" = {
            _props.allow-when-locked = true;
            spawn = shell [
              "media"
              "toggle"
            ];
          };
          "XF86AudioNext" = {
            _props.allow-when-locked = true;
            spawn = shell [
              "media"
              "next"
            ];
          };
          "XF86AudioPrev" = {
            _props.allow-when-locked = true;
            spawn = shell [
              "media"
              "previous"
            ];
          };

          "XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn = shell ["volume-up"];
          };
          "XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn = shell ["volume-down"];
          };
          "XF86AudioMute" = {
            _props.allow-when-locked = true;
            spawn = shell ["volume-mute"];
          };
          "XF86AudioMicMute" = {
            _props.allow-when-locked = true;
            spawn = shell ["mic-mute"];
          };
          "Shift+XF86AudioMute" = {
            _props.allow-when-locked = true;
            spawn = shell ["mic-mute"];
          };
          "Shift+XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn = shell ["mic-volume-up"];
          };
          "Shift+XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn = shell ["mic-volume-down"];
          };

          "XF86MonBrightnessUp" = {
            _props.allow-when-locked = true;
            spawn = shell ["brightness-up"];
          };
          "XF86MonBrightnessDown" = {
            _props.allow-when-locked = true;
            spawn = shell ["brightness-down"];
          };
        };
    }
    // lib.optionalAttrs (displays != {}) {
      output =
        lib.mapAttrsToList (
          name: display:
            {
              _args = [name];
              inherit (display) scale;
            }
            // lib.optionalAttrs (display.resolution != null) {
              mode =
                "${toString display.resolution.width}x${toString display.resolution.height}"
                + lib.optionalString (display.refreshRate != null) "@${toString display.refreshRate}";
            }
            // lib.optionalAttrs (display.position != null) {
              position._props = {inherit (display.position) x y;};
            }
            // lib.optionalAttrs display.variable-refresh-rate {
              variable-refresh-rate = [];
            }
        )
        displays;
    }
    // lib.optionalAttrs osConfig.cfg.host.laptop {
      switch-events.lid-close.spawn = shell [
        "session"
        "lock"
      ];
    };
}
