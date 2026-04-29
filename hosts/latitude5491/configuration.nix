{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../../modules/common/host.nix
    ../../modules/dual-function-keys/host.nix
    ../../modules/zram/host.nix
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [53317];
    allowedUDPPorts = [53317];
  };

  cfg.host = {
    displays.eDP-1 = {
      resolution = {
        width = 1368;
        height = 768;
      };
      scale = 0.7;
    };
    displays.HDMI-A-1 = {};
    webcam = true;
    laptop = true;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
