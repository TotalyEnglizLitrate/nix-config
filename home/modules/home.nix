{userConfig, ...}: {
  home = {
    username = "${userConfig.name}";
    homeDirectory = "/home/${userConfig.name}";
  };
}
