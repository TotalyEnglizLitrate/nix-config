{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./profile.nix
    ../../modules/server/host.nix
    ../../modules/server/auto-upgrade.nix
    ../../modules/stylix/server.nix
    ../../modules/vaultwarden/host.nix
  ];

  # Oracle Ampere A1 (4 OCPU / 24 GB)
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    # serial console for the Oracle console connection
    kernelParams = ["console=ttyAMA0,115200" "console=tty1"];
  };

  system.stateVersion = "26.05";
}
