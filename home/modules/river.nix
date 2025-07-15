{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  # tags
  all_tags = "4294967295"; # (1 << 32) - 1
  # 2^1 to 2^5
  browser_tag = "2";
  code_tag = "4";
  files_tag = "8";
  media_tag = "16";
  games_tag = "32";

  # binaries
  terminal = "foot";

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

  wayland.windowManager.river = {
    enable = true;
    package = null;
    xwayland.enable = true;

    settings = {
      border-width = 2;
      set-repeat = "30 300";
      default-attach-mode = "bottom";
      focus-follows-cursor = "always";
      set-cursor-warp = "on-focus-change";
      xcursor-theme = ["Bibata-Modern-Classic"];
      default-layout = "rivertile";

      declare-mode = ["normal" "locked" "passthrough" "floating"];

      hide-cursor = {
        when-typing = true;
        timeout = 10000;
      };

      input = {
        "pointer-1102-4639-DELL0818:00_044E:121F_Touchpad" = {
          tap = true;
          accel-profile = "flat";
          natural-scroll = true;
          events = true;
          disable-while-typing = true;
        };
      };

      spawn = [
        "'sleep 1 && systemctl --user restart cliphist.service cliphist-images.service kanshi.service foot.service'"
        "'pidof waybar || waybar'"
        "'pidof swww-daemon || swww-daemon --format xrgb'"
        "'swww restore'"
        "'walker --gapplication-service'"
        "'rivertile -main-count 1 -main-ratio 0.5 -outer-padding 0 -view-padding 0'"
        "swaync"
        "${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd"
        "kdeconnect-indicator"
        "nm-applet"
        "hypridle"
        "'${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1'"
        "arrpc"
      ];

      map.normal = {
        "Super B" = "spawn blueman-manager";
        "Super E" = "spawn nautilus";
        "Super F" = "toggle-fullscreen";
        "Super L" = "spawn hyprlock";
        "Super M" = "spawn '${terminal} -T btop btop'";
        "Super N" = "spawn 'swaync-client -t'";
        "Super Q" = "close";
        "Super C" = "spawn '${terminal} -a nvim nvim'";

        "Super R" = "spawn 'walker --modules applications,runner,emojis,calc,symbols,websearch,wallpapers'";

        "Super S" = "spawn 'spotify --enable-features=UseOzonePlatform --ozone-platform=wayland'";
        "Super T" = "spawn '${terminal} shell'";

        "Super V" = "spawn '${terminal} -T clipboard ${pkgs.cliphist}/bin/cliphist-fzf'";
        "Super+Shift V" = "spawn '${pkgs.cliphist}/bin/cliphist wipe'";

        "Super+Shift W" = "spawn 'swww img ${wallpapers}/$(ls ${wallpapers} | shuf -n 1)'";

        "Super W" = "spawn 'MOZ_ENABLE_WAYLAND=1 zen'";
        "Super+Shift B" = "spawn 'playerctl previous'";
        "Super+Shift F" = "toggle-float";
        "Super+Shift N" = "spawn 'playerctl next'";
        "Super+Shift P" = "spawn 'playerctl play-pause'";
        "Super+Shift Q" = "exit";
        "Super+Shift T" = "spawn ${terminal}";

        "None Print" = "spawn 'grim - | tee ${screenshots}/$(date \"+Screenshot_%d%m%y_%H%M%S\") | wl-copy'";
        "Super Print" = "spawn 'grim -g $(slurp) - | tee ${screenshots}/$(date \"+Screenshot_%d%m%y_%H%M%S\") | wl-copy'";

        "Super 0" = "set-focused-tags ${all_tags}";
        "Super+Shift 0" = "set-view-tags ${all_tags}";

        "Super Return" = "zoom"; # set currently focused window as main in tile group

        "Super Left" = "focus-view left";
        "Super Down" = "focus-view down";
        "Super Right" = "focus-view right";
        "Super Up" = "focus-view up";

        "Super+Alt Left" = "swap left";
        "Super+Alt Down" = "swap down";
        "Super+Alt Right" = "swap right";
        "Super+Alt Up" = "swap up";

        "Alt F" = "enter-mode floating";
        "Super Escape" = "enter-mode passthrough";
      };

      map.floating = {
        "Shift H" = "snap left";
        "Shift J" = "snap down";
        "Shift K" = "snap up";
        "Shift L" = "snap right";
        "None Escape" = "enter-mode normal";
      };

      map.passthrough."Super Escape" = "enter-mode normal";

      map-pointer.normal = {
        "Super+Alt BTN_LEFT" = "move-view";
        "Super+Alt BTN_RIGHT" = "resize-view";
      };

      map-switch.normal."lid close" = "spawn hyprlock";
    };

    extraConfig = ''
      # Floating mode repeat map
      riverctl map -repeat floating None H resize horizontal -25
      riverctl map -repeat floating None J resize vertical 25
      riverctl map -repeat floating None K resize vertical -25
      riverctl map -repeat floating None L resize horizontal 25

      riverctl map -repeat floating Super H move left 25
      riverctl map -repeat floating Super J move down 25
      riverctl map -repeat floating Super K move up 25
      riverctl map -repeat floating Super L move right 25
      # Workspace-esque tag shortcuts
      for i in $(seq 1 9); do
        equiv_tag=$((1<< ($i - 1)))
        riverctl map normal Super "$i" set-focused-tags $equiv_tag # Switch to
        riverctl map normal Super+Shift "$i" set-view-tags $equiv_tag # Move to
        riverctl map normal Super+Control "$i" toggle-focused-tags $equiv_tag # XOR with current tag
      done

      # maps for both normal and locked mode
      for mode in normal locked; do
        riverctl map $mode None XF86AudioPlay spawn "playerctl play-pause"
        riverctl map $mode None XF86AudioPrev spawn "playerctl previous"
        riverctl map $mode None XF86AudioNext spawn "playerctl next"
        riverctl map $mode None XF86AudioMute spawn "pamixer -t"
        riverctl map -repeat $mode None XF86AudioRaiseVolume spawn "pamixer -i 5"
        riverctl map -repeat $mode None XF86AudioLowerVolume spawn "pamixer -d 5"
        riverctl map -repeat $mode None XF86MonBrightnessUp spawn "brightnessctl s +5%"
        riverctl map -repeat $mode None XF86MonBrightnessDown spawn "brightnessctl s 5%-"
        riverctl map $mode Super+Shift P spawn "playerctl play-pause"
        riverctl map $mode Super+Shift B spawn "playerctl previous"
        riverctl map $mode Super+Shift N spawn "playerctl next"
        riverctl map $mode Super+Shift M spawn "pamixer -t"
      done


      # Make all views with app-id "bar" and any title use client-side decorations
      riverctl rule-add ssd

      riverctl rule-add -app-id "zen-twilight" tags ${browser_tag}
      riverctl rule-add -app-id "code" tags ${code_tag}
      riverctl rule-add -app-id "nvim" tags ${code_tag}
      riverctl rule-add -app-id "dev.zed.Zed" tags ${code_tag}
      riverctl rule-add -app-id "org.gnome.Nautilus" tags ${files_tag}
      riverctl rule-add -app-id "obsidian" tags ${code_tag}
      riverctl rule-add -app-id "Spotify" tags ${media_tag}
      riverctl rule-add -title "Special Offers" tags ${games_tag}
      riverctl rule-add -title "Friends List" tags ${games_tag}
      riverctl rule-add -title "Steam Settings" tags ${games_tag}


      riverctl rule-add -title "Special Offers" float # Steam
      riverctl rule-add -title "Friends List" float   # Steam
      riverctl rule-add -title "Steam Settings" float # Steam

      riverctl rule-add -app-id ".blueman-manager-wrapped" float
      riverctl rule-add -app-id "org.kde.kdeconnect.app" float
      riverctl rule-add -app-id "org.gnome.Nautilus" float
      riverctl rule-add -app-id "nm-connection-editor" float
      riverctl rule-add -app-id "org.kde.polkit-kde-authentication-agent-1" float
      riverctl rule-add -app-id "polkit-gnome-authentication-agent-1" float

      riverctl rule-add -title 'gtk*' float
      riverctl rule-add -title 'btop' float
      riverctl rule-add -title 'btop' dimensions 1000 600
      riverctl rule-add -title 'batmon' float
      riverctl rule-add -title 'batmon' dimensions 1000 600
      riverctl rule-add -title 'clipboard' dimensions 1000 600
      riverctl rule-add -title 'clipboard' float
      riverctl rule-add -app-id 'GParted' float
      riverctl rule-add -app-id 'nwg-look' float
      riverctl rule-add -app-id 'zen-twilight' -title 'Picture-in-Picture' float
      riverctl rule-add -app-id 'zen-twilight' -title 'Extension:*' float
      riverctl rule-add -app-id 'xdg-desktop-portal-gtk' float
      riverctl rule-add -app-id "Spotify" float
      riverctl rule-add -app-id 'org.pulseaudio.pavucontrol' float
      riverctl rule-add -app-id float float
      riverctl rule-add -title "popup title with spaces" float
      riverctl rule-add -title "zoom" float
      riverctl rule-add -title "Picture-in-Picture" float
    '';
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
