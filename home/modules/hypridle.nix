{...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }

        {
          timeout = 360;
          on-timeout = "systemctl sleep";
        }
      ];
    };
  };
}
