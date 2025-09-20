{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu.swtpm.enable = true;
    qemu.vhostUserPackages = [pkgs.virtiofsd];
    qemu.package = pkgs.qemu_kvm;
  };

  services.libvirtd = {
    autoSnapshot = {
      enable = true;
      keep = 1;
      calendar = "12:00:00";
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-boxes
  ];
}
