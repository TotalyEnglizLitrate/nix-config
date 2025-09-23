{inputs, ...}: {
  stylix.targets.nixvim.enable = true;
  home.packages = [inputs.nixvim.full];
}
