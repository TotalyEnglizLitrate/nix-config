{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}; [
    nvim
    neovide
  ];
}
