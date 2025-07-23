{
  inputs,
  hostname,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../modules/common.nix
    ../modules/dual-function-keys.nix
    ../modules/river.nix
    ../modules/steam.nix
    ../modules/laptop.nix
    ../modules/cloudflare-warp.nix
    ../modules/ly.nix
    ../modules/zram.nix
  ];

  # Set hostname
  networking.hostName = hostname;

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
}
