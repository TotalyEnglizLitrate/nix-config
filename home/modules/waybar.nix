{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        fixed-center = true;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        margin-bottom = 0;

        modules-left = [
          "niri/workspaces"
        ];

        modules-center = [
          "clock"
          "custom/notification"
        ];

        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "pulseaudio#microphone"
          "cpu"
          "memory"
          "backlight"
          "battery"
        ];

        backlight = {
          interval = 2;
          align = 0;
          rotate = 0;
          format = "{icon} {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃝" "󰃠"];
          icon-size = 10;
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
          smooth-scrolling-threshold = 1;
        };

        battery = {
          interval = 60;
          align = 0;
          rotate = 0;
          full-at = 100;
          design-capacity = false;
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "<big>{icon}</big> {capacity}%";
          format-charging = "󱐋 ";
          format-plugged = "󱐤 ";
          format-full = "{icon} ";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-time = "{H}h {M}min";
          tooltip = true;
          tooltip-format = "{capacity}%\n{timeTo} {power}w";
          on-click-right = "${pkgs.foot}/bin/foot -T batmon ${pkgs.batmon}/bin/batmon";
        };

        bluetooth = {
          format = "";
          format-connected = " {num_connections}";
          tooltip-format = " {device_alias}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "Name: {device_alias}\nBattery: {device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        clock = {
          format = "{:%b %d %H:%M}";
          format-alt = "{:%H:%M %Y, %d %B, %A}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = "󰍛 {usage}%";
          interval = 1;
        };

        memory = {
          interval = 10;
          format = "󰾆 {used:0.1f}G";
          format-alt = "󰾆 {percentage}%";
          format-alt-click = "click";
          tooltip = true;
          tooltip-format = "{used:0.1f}GB/{total:0.1f}G";
          on-click-right = "${pkgs.foot}/bin/foot -T btop ${pkgs.btop}/bin/btop";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          scroll-step = 5;
          on-click-right = "pamixer -t";
          smooth-scrolling-threshold = 1;
          ignored-sinks = ["Easy Effects Sink"];
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "pavucontrol";
          on-click-right = "pamixer --default-source -t";
          on-scroll-up = "pamixer --default-source -i 5";
          on-scroll-down = "pamixer --default-source -d 5";
        };

        tray = {
          spacing = 20;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󰂚 <span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "󰂛 <span foreground='red'><sup></sup></span>";
            dnd-none = " ";
            inhibited-notification = "";
            inhibited-none = "";
            dnd-inhibited-notification = "󰂛 ";
            dnd-inhibited-none = " ";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        network = {
          interval = 5;
          family = "ipv4_6";
          format = "{icon}";
          format-ethernet = "󰈀 ";
          format-disconnected = "󰤮 ";
          format-disabled = "󰣽 ";
          format-icons = ["󰤫 " "󰤟 " "󰤢 " "󰤥 " "󰤨 "];
          on-click = "nm-connection-editor";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{bandwidthDownBytes} down; {bandwidthUpBytes} up";
          tooltip-format-ethernet = "{ifname}  ";
          tooltip-format-disconnected = "Disconnected";
        };
      };
    };
    style = ''
      * {
        font-weight: bold;
        font-size: 12pt;
        min-height: 0;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        padding: 0px;
        margin: 2px;
      }

      window#waybar {
        margin: 0px;
        padding: 0px;
      }

      window#waybar.hidden {
        opacity: 1;
      }

      tooltip {
        border-radius: 0px;
      }

      tooltip label {
        color: #cad3f5;
        margin-right: 5px;
        margin-left: 5px;
      }

      .modules-right,
      .modules-center,
      .modules-left {
        border: rgba(0,0,0,1);
        border-radius: 0px;
        padding: 0px;
        margin: 0px;
      }

      #tags button {
        padding: 2px;
        color: #6e6a86;
        margin-right: 2px;
      }

      #tags button.focused {
        color: #d8dee9;
      }

      #tags button.urgent {
        color: #ed8796;
        border-radius: 0px;
      }

      #mode {
        margin-left: 2px;
        margin-right: 10px;
      }

      #backlight,
      #battery,
      #bluetooth,
      #clock,
      #cpu,
      #custom-notification,
      #memory,
      #tray,
      #pulseaudio,
      #custom-temperature,
      #tags {
        color: #dfdfdf;
        padding: 0px 4px;
        border-radius: 0px;
      }

      @keyframes blink {
        to {
          color: #000000;
        }
      }

      #battery.critical:not(.charging) {
        color: #f53c3c;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';
  };
}
