{
  pkgs,
  lib,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }

        {
          timeout = 1800;
          on-timeout = "systemctl sleep";
        }
      ];
    };
  };
}
