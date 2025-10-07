{ pkgs, userConfig, ... }: {
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
    };
  };

  users.users.${userConfig.name}.extraGroups = [ "podman" "docker" "video" ];

  environment.systemPackages = [ pkgs.distrobox ];
}
