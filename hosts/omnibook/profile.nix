_: {
  cfg.host = {
    displays = {
      eDP-1 = {
        resolution = {
          width = 2240;
          height = 1400;
        };
        scale = 1.0;
      };
      DP-1 = {}; # thunderbolt
      DP-2 = {}; # thunderbolt
      DP-3 = {}; #thunderbolt -> dock
    };
    webcam = true;
    laptop = true;
    IRCam = {
      enable = true;
      path = "usb:04f2:b80d";
    };
    fprint = true;
    gpu.amd = true;
  };
}
