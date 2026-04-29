{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../../modules/common/host.nix
    ../../modules/mute-led-daemon/host.nix
    ../../modules/docker/host.nix
    ../../modules/qemu/host.nix
    # ../../modules/android-dev/host.nix
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [53317];
    allowedUDPPorts = [53317];
  };

  nixpkgs.config.allowUnfree = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11";

  boot = {
    kernelModules = ["amdgpu"];
    loader = {
      systemd-boot.edk2-uefi-shell.enable = true;
      systemd-boot.windows = {
        "Spyware" = {
          title = "Spyware";
          efiDeviceHandle = "HD0b";
        };
      };
    };
  };

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
    fprint = true;
    gpu.amd = true;
  };
}
