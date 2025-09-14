{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../modules/common.nix
    ../modules/dual-function-keys.nix
    ../modules/steam.nix
    ../modules/zram.nix
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [53317];
    allowedUDPPorts = [53317];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
