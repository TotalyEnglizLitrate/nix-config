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
    ../modules/hyprland.nix
    ../modules/steam.nix
    ../modules/laptop.nix
    ../modules/corectrl.nix
    ../modules/cloudflare-warp.nix
    ../modules/sddm.nix
  ];

  # Set hostname
  networking.hostName = hostname;

  nixpkgs.config.allowUnfree = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11";
}
