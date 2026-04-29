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

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
