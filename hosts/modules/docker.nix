{
  pkgs,
  userConfig,
  ...
}: {
  virtualisation = {
    docker = {
      enable = false;
      rootless = {
        enable = false;
        setSocketVariable = true;
        daemon.settings = {
          storage-driver = "btrfs";
        };
      };
    };

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = [pkgs.podman-compose];
    };
  };

  users.users.${userConfig.name}.extraGroups = ["podman" "docker" "video"];

  environment.systemPackages = [pkgs.distrobox];
}
