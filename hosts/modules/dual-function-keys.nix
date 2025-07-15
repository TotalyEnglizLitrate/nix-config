{pkgs, ...}: {
  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          NAME: AT Translated Set 2 keyboard
    '';
  };

  # Create the configuration file for dual-function-keys
  environment.etc."dual-function-keys.yaml".text = ''
    MAPPINGS:
      - KEY: KEY_RIGHTSHIFT
        TAP: KEY_ENTER
        HOLD: KEY_RIGHTSHIFT
        HOLD_START: BEFORE_CONSUME_OR_RELEASE
      - KEY: KEY_RIGHTALT
        TAP: KEY_RIGHTMETA
        HOLD: KEY_LEFTMETA
        HOLD_START: BEFORE_CONSUME_OR_RELEASE
      - KEY: KEY_LEFTMETA
        TAP: KEY_RIGHTMETA
        HOLD: KEY_LEFTMETA
        HOLD_START: BEFORE_CONSUME_OR_RELEASE
  '';

  environment.systemPackages = with pkgs; [
    interception-tools-plugins.dual-function-keys
  ];
}
