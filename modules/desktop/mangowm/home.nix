{
  lib,
  outputs,
  config,
  osConfig,
  pkgs,
  ...
}: let
  noctalia = lib.getExe pkgs.noctalia;
  ipc = args: "${noctalia} msg ${lib.concatStringsSep " " args}";
  cmd = lib.concatStringsSep " ";
in {
  nixpkgs.overlays = [
    outputs.overlays.mango
    outputs.overlays.noctalia
    outputs.overlays.helium
  ];
  imports = [../common];

  wayland.windowManager.mango.enable = true;
  wayland.windowManager.mango.package = pkgs.mango;

  wayland.windowManager.mango.autostart_sh = ''
    QT_QPA_PLATFORM_THEME=qt6ct ${noctalia} -d &
    toggle-mute --init &
    ${lib.getExe pkgs.arrpc} &
    ${pkgs.kdePackages.kdeconnect-kde}/lib/kdeconnectd &
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
  '';

  wayland.windowManager.mango.settings = let
    displays = osConfig.cfg.host.displays;

    floatRule = geometry: appid: "isfloating:1,${geometry},appid:${appid}";

    bitwarden = "^chrome-nngceckbapebfimnlniiiahkandclblb.*$";

    inherit (osConfig.lib.stylix) colors;
    mkColor = alpha: base: "0x${colors.${base}}${alpha}";
    color = mkColor "ff";
  in {
    blur = 1;
    blur_layer = 1;
    blur_optimized = 0;
    blur_params_num_passes = 1;
    blur_params_radius = 2;
    blur_params_noise = 0.02;
    blur_params_brightness = 0.9;
    blur_params_contrast = 0.9;
    blur_params_saturation = 1.2;

    shadows = 1;
    layer_shadows = 1;
    shadow_only_floating = 1;
    shadows_size = 12;
    shadows_blur = 15;
    shadows_position_x = 0;
    shadows_position_y = 0;
    shadowscolor = color "base00";

    border_radius = 6;
    no_radius_when_single = 0;
    focused_opacity = 0.8;
    unfocused_opacity = 0.6;

    animations = 1;
    layer_animations = 1;
    animation_type_open = "zoom";
    animation_type_close = "zoom";
    layer_animation_type_open = "zoom";
    layer_animation_type_close = "zoom";
    animation_fade_in = 1;
    animation_fade_out = 1;
    tag_animation_direction = 0;
    zoom_initial_ratio = 0.4;
    zoom_end_ratio = 0.7;
    fadein_begin_opacity = 0.8;
    fadeout_begin_opacity = 0.8;
    animation_duration_move = 200;
    animation_duration_open = 180;
    animation_duration_tag = 180;
    animation_duration_close = 150;
    animation_duration_focus = 100;
    animation_curve_open = "0.25,1,0.5,1";
    animation_curve_move = "0.25,1,0.5,1";
    animation_curve_tag = "0.25,1,0.5,1";
    animation_curve_close = "0.25,1,0.5,1";
    animation_curve_focus = "0.25,1,0.5,1";
    animation_curve_opafadeout = "0.25,1,0.5,1";
    animation_curve_opafadein = "0.25,1,0.5,1";

    scroller_structs = 0;
    scroller_default_proportion = 1.0;
    scroller_focus_center = 0;
    scroller_prefer_center = 1;
    edge_scroller_pointer_focus = 1;
    scroller_ignore_proportion_single = 0;
    scroller_default_proportion_single = 1.0;
    scroller_proportion_preset = "0.5,1.0";

    new_is_master = 1;
    smartgaps = 0;
    default_mfact = 0.55;
    default_nmaster = 1;

    dwindle_smart_split = 1;
    dwindle_drop_simple_split = 1;
    dwindle_manual_split = 0;
    dwindle_hsplit = 0;
    dwindle_vsplit = 0;
    dwindle_preserve_split = 1;

    hotarea_size = 10;
    enable_hotarea = 1;
    ov_tab_mode = 0;
    overviewgappi = 5;
    overviewgappo = 30;

    xwayland_persistence = 1;
    syncobj_enable = 1;
    no_border_when_single = 0;
    axis_bind_apply_timeout = 100;
    focus_on_activate = 1;
    sloppyfocus = 1;
    warpcursor = 1;
    focus_cross_monitor = 0;
    focus_cross_tag = 0;
    circle_layout = "scroller,dwindle";
    enable_floating_snap = 1;
    snap_distance = 50;
    cursor_size = osConfig.stylix.cursor.size;
    cursor_theme = osConfig.stylix.cursor.name;
    cursor_hide_timeout = 0;
    drag_tile_to_tile = 1;
    single_scratchpad = 1;

    repeat_rate = 25;
    repeat_delay = 600;
    numlockon = 1;

    disable_trackpad = 0;
    tap_to_click = 1;
    tap_and_drag = 1;
    drag_lock = 1;
    mouse_natural_scrolling = 0;
    trackpad_natural_scrolling = 1;
    disable_while_typing = 1;
    left_handed = 0;
    middle_button_emulation = 0;
    swipe_min_threshold = 1;
    mouse_accel_profile = 2;
    mouse_accel_speed = 0.4;

    gappih = 0;
    gappiv = 0;
    gappoh = 0;
    gappov = 0;
    scratchpad_width_ratio = 0.8;
    scratchpad_height_ratio = 0.9;
    borderpx = 4;
    rootcolor = color "base00";
    maximizescreencolor = color "base00";
    bordercolor = color "base02";
    focuscolor = color "base0D";
    urgentcolor = color "base08";
    splitcolor = color "base09";
    overlaycolor = color "base0B";
    dropcolor = mkColor "55" "base0B";
    globalcolor = color "base0E";
    scratchpadcolor = color "base0F";

    tagrule = map (id: "id:${toString id},layout_name:scroller") (lib.range 1 9);

    monitorrule =
      lib.mapAttrsToList (
        name: display:
          lib.concatStringsSep "," (
            [
              "name:^${name}$"
              "scale:${toString display.scale}"
            ]
            ++ lib.optionals (display.resolution != null) [
              "width:${toString display.resolution.width}"
              "height:${toString display.resolution.height}"
            ]
            ++ lib.optional (display.refreshRate != null) "refresh:${toString display.refreshRate}"
            ++ lib.optionals (display.position != null) [
              "x:${toString display.position.x}"
              "y:${toString display.position.y}"
            ]
            ++ lib.optional display.variable-refresh-rate "vrr:1"
          )
      )
      displays;

    windowrule =
      map (floatRule "width:0.4,height:0.45") [
        "^[Ss]potify$"
        "^org\.gnome\.Nautilus$"
        "^org\.gnome\.FileRoller$"
        "^org\.pulseaudio\.pavucontrol$"
        "^nm-connection-editor$"
      ]
      ++ map (floatRule "width:0.56,height:0.85") [
        "^dev\.noctalia\.Noctalia$"
      ]
      ++ map (floatRule "width:0.2,height:0.5") [
        bitwarden
        "^org\.kde\.kdeconnect\..*$"
      ]
      ++ map (appid: "shield_when_capture:1,appid:${appid}") [
        bitwarden
        "^org\.gnome\.seahorse\.Application$"
      ]
      ++ map (appid: "focused_opacity:1,unfocused_opacity:1,appid:${appid}") [
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

    layerrule =
      map (name: "noanim:1,noshadow:1,layer_name:^${name}$") [
        "noctalia-attached-panel"
        "noctalia-screenshot-region"
        "noctalia-window-switcher"
        "noctalia-bar-.*"
        "noctalia-osd"
        "noctalia-notification"
      ]
      ++ [
        "noblur:1,layer_name:^noctalia-bar-.*$"
      ];

    bind = with config.commandsList;
      lib.optional osConfig.cfg.host.bluetooth
      "SUPER,b,spawn,${ipc ["panel-toggle" "control-center" "bluetooth"]}"
      ++ [
        "SUPER,t,spawn,${cmd terminal}"
        "SUPER,w,spawn,${cmd browser}"
        "SUPER,e,spawn,${cmd fileManager}"
        "SUPER,m,spawn,${cmd sysmon}"
        "SUPER,s,spawn,spotify"
        "SUPER,n,spawn,${ipc ["panel-toggle" "control-center" "notifications"]}"
        "SUPER,r,spawn,${ipc ["panel-toggle" "launcher"]}"
        "SUPER,v,spawn,${ipc ["panel-toggle" "clipboard"]}"
        "SUPER,a,spawn,${ipc ["panel-toggle" "control-center"]}"
        "SUPER+SHIFT,v,spawn,${ipc ["panel-toggle" "control-center" "audio"]}"
        "SUPER+SHIFT,w,spawn,${ipc ["wallpaper-random"]}"
        "SUPER+SHIFT,q,spawn,${ipc ["panel-toggle" "session"]}"
        "SUPER,l,spawn,${ipc ["session" "lock"]}"

        "SUPER,Tab,togglejump"
        "Alt,Tab,spawn,${ipc ["window-switcher"]}"
        "SUPER,q,killclient"
        "SUPER,i,minimized"
        "SUPER+SHIFT,i,restore_minimized,0"
        "SUPER,d,switch_proportion_preset"
        "SUPER,f,togglefullscreen"
        "SUPER+SHIFT,f,togglefloating"
        "SUPER,c,centerwin"
        "SUPER+CTRL,f,set_proportion,1.0"
        "SUPER+SHIFT,s,switch_layout"
        "SUPER+SHIFT,r,reload_config"

        "SUPER,Left,focus_window_or_workspace,left"
        "SUPER,Down,focus_window_or_workspace,down"
        "SUPER,Up,focus_window_or_workspace,up"
        "SUPER,Right,focus_window_or_workspace,right"

        "SUPER+SHIFT,h,exchange_client,left"
        "SUPER+SHIFT,j,exchange_client,down"
        "SUPER+SHIFT,k,exchange_client,up"
        "SUPER+SHIFT,l,exchange_client,right"

        "SUPER,bracketleft,scroller_stack,left"
        "SUPER,bracketright,scroller_stack,right"

        "SUPER,minus,setmfact,-0.05"
        "SUPER,equal,setmfact,+0.05"
        "SUPER+SHIFT,minus,resizewin,+0,-50"
        "SUPER+SHIFT,equal,resizewin,+0,+50"

        "SUPER,Page_Down,viewtoright,0"
        "SUPER,Page_Up,viewtoleft,0"
        "SUPER+CTRL,Page_Down,tagtoright,0"
        "SUPER+CTRL,Page_Up,tagtoleft,0"

        "SUPER+ALT,Left,focusmon,left"
        "SUPER+ALT,Right,focusmon,right"
        "SUPER+ALT+SHIFT,Left,tagmon,left"
        "SUPER+ALT+SHIFT,Right,tagmon,right"

        "SUPER,Print,spawn,${ipc ["screenshot-region"]}"
        "NONE,Print,spawn,${ipc ["screenshot-fullscreen"]}"

        "CTRL+ALT,Delete,quit"
      ]
      ++ map (n: "SUPER,${toString n},view,${toString n},0") (lib.range 1 9)
      ++ map (n: "SUPER+CTRL,${toString n},tag,${toString n},0") (lib.range 1 9)
      ++ map (n: "ALT,${toString n},toggleview,${toString n}") (lib.range 1 9);

    bindl = [
      "SUPER+SHIFT,b,spawn,${ipc ["media" "previous"]}"
      "SUPER+SHIFT,p,spawn,${ipc ["media" "playPause"]}"
      "SUPER+SHIFT,n,spawn,${ipc ["media" "next"]}"
      "NONE,XF86AudioPlay,spawn,${ipc ["media" "toggle"]}"
      "NONE,XF86AudioPause,spawn,${ipc ["media" "toggle"]}"
      "NONE,XF86AudioNext,spawn,${ipc ["media" "next"]}"
      "NONE,XF86AudioPrev,spawn,${ipc ["media" "previous"]}"

      "NONE,XF86AudioRaiseVolume,spawn,${ipc ["volume-up"]}"
      "NONE,XF86AudioLowerVolume,spawn,${ipc ["volume-down"]}"
      "NONE,XF86AudioMute,spawn,${ipc ["volume-mute"]}"
      "NONE,XF86AudioMicMute,spawn,${ipc ["mic-mute"]}"
      "SHIFT,XF86AudioMute,spawn,${ipc ["mic-mute"]}"
      "SHIFT,XF86AudioRaiseVolume,spawn,${ipc ["mic-volume-up"]}"
      "SHIFT,XF86AudioLowerVolume,spawn,${ipc ["mic-volume-down"]}"

      "NONE,XF86MonBrightnessUp,spawn,${ipc ["brightness-up"]}"
      "NONE,XF86MonBrightnessDown,spawn,${ipc ["brightness-down"]}"
    ];

    axisbind = [
      "SUPER,UP,viewtoleft"
      "SUPER,DOWN,viewtoright"
      "SUPER+CTRL,UP,tagtoleft"
      "SUPER+CTRL,DOWN,tagtoright"
      "SUPER+SHIFT,UP,focusdir,left"
      "SUPER+SHIFT,DOWN,focusdir,right"
      "SUPER+CTRL+SHIFT,UP,exchange_client,left"
      "SUPER+CTRL+SHIFT,DOWN,exchange_client,right"
    ];

    mousebind = [
      "SUPER,btn_left,moveresize,curmove"
      "SUPER,btn_right,moveresize,curresize"
      "SUPER+CTRL,btn_left,minimized"
      "SUPER+CTRL,btn_right,restore_minimized,0"
      "SUPER,btn_middle,togglefullscreen"
    ];

    gesturebind = [
      "none,left,3,focusstack,next"
      "none,right,3,focusstack,prev"
      "none,up,3,viewtoright"
      "none,down,3,viewtoleft"
      "none,up,4,togglejump,1"
      "none,down,4,togglejump,1"
    ];
  };
}
