{inputs, ...}: {
  stylix.targets.nixvim.enable = true;
  home.packages = [inputs.nvix.full];
}
