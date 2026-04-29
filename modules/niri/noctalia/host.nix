{lib, ...}: {
  nix.settings = {
    extra-substituters = lib.mkAfter ["https://noctalia.cachix.org"];
    trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };
}
