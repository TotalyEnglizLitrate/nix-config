{
  lib,
  pkgs,
  inputs,
  config,
  cfg,
  cmdsList,
  ...
}: let
  enablePlugins = names: src:
    lib.genAttrs names (_: {
      enabled = true;
      sourceUrl = src;
    });
  plugins_src = "https://github.com/noctalia-dev/noctalia-plugins";
in {
  imports = [inputs.noctalia.homeModules.default];

  nixpkgs.overlays = [inputs.noctalia.overlays.default];
  cfg.commands.noctalia = {
    package = pkgs.noctalia-shell;
    args = ["-d"];
  };

  programs.noctalia-shell = {
    package = pkgs.noctalia-shell;
    enable = true;
    settings = {
      dock.enabled = false;
      audio.volumeOverdrive = true;
      brightness.enforceMinimum = false;
      systemMonitor.externalMonitor = lib.join " " cmdsList.sysmon;

      idle = {
        enabled = true;
        screenOffTimeout = 90;
        lockTimeout = 300;
        suspendTimeout = 600;
        suspendCommand = lib.join " " (cmdsList.noctaliaIPC ++ ["lockScreen" "lock"]);
      };

      bar = {
        barType = "simple";
        density = "spacious";
        position = "top";
        enableExclusionZoneInset = false;
        outerCorners = false;
        reverseScroll = true;
        rightClickAction = "none";

        widgets = {
          left = [
            {id = "Workspace";}
            {
              id = "ActiveWindow";
              maxWidth = 300;
            }
            {id = "plugin:screen-toolkit";}
            {id = "plugin:sticky-notes";}
            {id = "plugin:todo";}
          ];

          center = [
            {id = "NotificationHistory";}
            {id = "Clock";}
            {id = "plugin:timer";}
            {id = "plugin:catwalk";}
          ];

          right =
            [
              {
                id = "SystemMonitor";
                compactMode = false;
                showNetworkStats = true;
              }
              {id = "Tray";}
              {id = "plugin:kde-connect";}
              {id = "Network";}
              {id = "plugin:network-manager-vpn";}
            ]
            ++ lib.optional cfg.host.bluetooth {id = "Bluetooth";}
            ++ [
              {id = "plugin:privacy-indicator";}
              {id = "Brightness";}
              {
                id = "Battery";
                displayMode = "icon-always";
                showPowerProfiles = true;
                showNoctaliaPerformance = true;
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
        };
      };

      notifications.sounds = {
        enabled = true;
        excludedApps = "";
      };

      general = let
        inherit (cfg.host) fprint;
      in {
        enableShadows = false;
        reverseScroll = true;
        lockScreenAnimation = true;
        enableLockScreenMediaControls = true;
        autoStartAuth = fprint;
        allowPasswordWithFprintd = fprint;
        clockFormat = "hh:mm:ss";
      };

      ui = {
        scrollBarAlwaysVisible = false;
        panelsAttachedToBar = false;
        settingsPanelMode = "center";
        settingsPanelSideBarCardStyle = true;
      };

      location = {
        autoLocate = false;
        weatherEnabled = false;
      };

      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }

          {
            enabled = true;
            id = "calendar-month-card";
          }

          {
            enabled = false;
            id = "weather-card";
          }
        ];
      };

      controlCenter = {
        shortcuts = {
          left =
            [{id = "Network";}]
            ++ lib.optional cfg.host.bluetooth {id = "Bluetooth";}
            ++ [
              {id = "AirplaneMode";}
              {id = "KeepAwake";}
              {id = "NightLight";}
            ];

          right = [];
        };

        cards = [
          {
            enabled = true;
            id = "profile-card";
          }

          {
            enabled = true;
            id = "shortcuts-card";
          }

          {
            enabled = true;
            id = "brightness-card";
          }

          {
            enabled = true;
            id = "audio-card";
          }

          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };

      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = true;
        terminalCommand = lib.join " " (cmdsList.terminal ++ ["-e"]);
        showCategories = false;
      };

      wallpaper = {
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        useOriginalImages = true;
        viewMode = "browse";
        transitionType = [
          "stripes"
          "honeycomb"
        ];
      };
    };

    plugins = {
      version = 2;
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = plugins_src;
        }
      ];

      states =
        enablePlugins [
          "catwalk"
          "screen-toolkit"
          "file-search"
          "privacy-indicator"
          "sticky-notes"
          "web-search"
          "todo"
          "keybind-cheatsheet"
          "network-manager-vpn"
          "timer"
          "kde-connect"
          "nvim-session-provider"
          "unicode-picker"
          "kaomoji-provider"
          "show-keys"
        ]
        plugins_src;
    };
  };

  # plugin deps
  home.packages = with pkgs; [
    # screen-toolkit
    grim
    slurp
    tesseract
    imagemagick
    zbar
    wl-screenrec

    # kde-connect
    sshfs

    # show-keys
    evtest

    # is already a dep of noctalia upstream; just needed to run cliphist wipe when necessary
    cliphist
  ];
}
