{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../modules/common.nix
    ../modules/zram.nix
    ../modules/preload.nix
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

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 40;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };
}
