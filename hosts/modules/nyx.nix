{
  inputs,
  userConfig,
  ...
}: let
  nixdir = "/home/${userConfig.name}/Documents/repositories/nix-config";
in {
  imports = [inputs.nyx.nixosModules.default];
  nyx = {
    enable = true;
    username = "engliz";
    nixDirectory = nixdir;
    logDir = "${nixdir}/.nyx-logs";
    autoPush = false;

    nyx-tool.enable = true;
    nyx-rebuild.enable = true;
    nyx-cleanup.enable = true;
  };
}
