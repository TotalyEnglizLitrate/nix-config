_: {
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = [
      {
        profile.name = "docked-dp1";
        profile.outputs = [
          {
            criteria = "DP-1";
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
        profile.name = "extend-dp1-right";
        profile.outputs = [
          {
            criteria = "DP-1";
            status = "enable";
            position = "2240,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
        ];
      }

      {
        profile.name = "docked-dp2";
        profile.outputs = [
          {
            criteria = "DP-2";
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
        profile.name = "extend-dp2-right";
        profile.outputs = [
          {
            criteria = "DP-2";
            status = "enable";
            position = "2240,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
        ];
      }

      {
        profile.name = "docked-dp3";
        profile.outputs = [
          {
            criteria = "DP-3";
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
        profile.name = "extend-dp3-right";
        profile.outputs = [
          {
            criteria = "DP-2";
            status = "enable";
            position = "2240,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
        ];
      }

      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            transform = "normal";
          }
        ];
      }

      {
        profile.name = "portrait";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            transform = "90";
          }
        ];
      }

    ];
  };
}
