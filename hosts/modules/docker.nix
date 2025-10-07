{ userConfig, ... }: {
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        storage-driver = "btrfs";
      };

    };
  };
  users.users.${userConfig.name}.extraGroups = [ "docker" "video" ];
}
