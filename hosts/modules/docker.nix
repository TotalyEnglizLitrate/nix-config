{userConfig, ...}: {
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.users.${userConfig.name}.extraGroups = ["docker" "video"];
}
