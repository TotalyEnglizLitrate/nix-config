{
  inputs,
  pkgs,
  ...
}: {
  stylix.targets.nixvim.enable = true;
  home.packages = [inputs.nvix.packages.${pkgs.system}.default];
}
