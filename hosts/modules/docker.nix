{userConfig, ...}: {
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.users.${userConfig.name}.extraGroups = ["docker" "video"];
}
