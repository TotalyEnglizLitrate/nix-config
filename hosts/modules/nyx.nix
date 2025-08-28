{inputs, ...}: {
  imports = [inputs.nyx.nixosModules.default];
  nyx = {
    enable = true;
    username = "engliz";
    nixDirectory = "/home/engliz/Documents/repositories/nix-config/";
    logDir = "/home/engliz/.cache/nyx/logs";
    autoPush = false;

    nyx-tool.enable = true;
    nyx-rebuild.enable = true;
    nyx-cleanup.enable = true;
    nyx-tui.enable = true;
  };
}
