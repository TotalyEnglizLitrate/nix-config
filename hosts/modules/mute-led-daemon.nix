{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3Minimal
  ];

  systemd.services.mute-led-fix = {
    enable = true;
    after = ["sound.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.python3}/bin/python3 ${../../files/scripts/mute-led-fixd.py}";
      PIDFile = "/var/run/mute-led-fix/pid";
      Restart = "on-abnormal";
    };
  };
}
