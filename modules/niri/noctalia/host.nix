{inputs, config, ...}: {
  imports = [inputs.noctalia-greetd.nixosModules.default];
  programs.noctalia-greeter = {
    enable = true;
    settings = {
      appearance.scheme = "Synced";
      cursor = with config.stylix.cursor; {
        theme = name;
        inherit size;
        path = "${package.outPath}/share/icons";
      };
    };
  };

  nix.settings = {
    substituters = ["https://noctalia.cachix.org"];
    trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };
}
