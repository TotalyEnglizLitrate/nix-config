# Oracle Ampere A1 (KVM guest). Module list from `nixos-generate-config --show-hardware-config`;
# filesystems mount by label, matching the partitioning done at install time:
#   sda1 = fat32 "BOOT" (ESP), sda2 = btrfs "nixos" with subvolumes @ @nix @home @log
{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid"];

  # copy-on-write btrfs with transparent zstd compression
  fileSystems = let
    btrfs = subvol: {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=${subvol}" "compress=zstd:3" "noatime"];
    };
  in {
    "/" = btrfs "@";
    "/nix" = btrfs "@nix";
    "/home" = btrfs "@home";
    "/var/log" = btrfs "@log";
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  services.btrfs.autoScrub.enable = true;

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
