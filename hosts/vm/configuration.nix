{
  modulesPath,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    "${lib.toString modulesPath}/profiles/qemu-guest.nix"
    ../../modules/common/host.nix
    ../../modules/niri/host.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    kernelParams = ["random.trust_cpu=on"];
    kernelModules = ["virtio_console"];
    loader.grub.enable = true;
    loader.grub.device = "/dev/vda";
    loader.grub.efiSupport = false;
    loader.systemd-boot.enable = lib.mkForce false;
  };


  system.build.qcow2 = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;

    diskSize = 65536;
    memSize = 16384;

    format = "qcow2";

    partitionTableType = "legacy";
  };

  networking.firewall.enable = lib.mkForce false;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  cfg.host = {
    hostname = "vm";

    gpu = {};

    bluetooth = false;
    fprint = false;
    webcam = false;
    laptop = false;

    displays = {};
  };

  system.stateVersion = "24.11";
}
