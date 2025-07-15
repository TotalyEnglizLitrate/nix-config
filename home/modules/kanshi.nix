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
          }
        ];
        profile.exec = "${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --custom-mode 1600x900@60Hz";
      }
      {
        profile.name = "mirror";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
          }
        ];
        profile.exec = "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --mirror eDP-1";
      }
    ];
  };
}
