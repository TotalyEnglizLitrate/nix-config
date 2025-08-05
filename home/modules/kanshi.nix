{pkgs, ...}: {
  # Install kanshi via home-manager module
  home.packages = with pkgs; [
    kanshi
  ];

  # Manage kanshi services via Home-manager
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = [
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
            scale = 0.7;
          }
        ];
      }
      {
        profile.name = "extend-left";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
            scale = 0.7;
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "-1366,0";
          }
        ];
      }
      {
        profile.name = "extend-right";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
            scale = 0.7;
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "1366,0";
          }
        ];
      }
      {
        profile.name = "extend-top";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
            mode = "--custom 1920x1080@60Hz";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,900";
          }
        ];
      }
    ];
  };
}
