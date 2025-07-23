{pkgs, ...}: {
  services.zram-generator.enable = true;
  services.zram-generator.settings = {
    zram0.zram-size = 6144;
    host-memory-limit = "none";
  };

  environment.systemPackages = with pkgs; [zram-generator];
}
