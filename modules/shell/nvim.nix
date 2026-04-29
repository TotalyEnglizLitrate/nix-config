{pkgs, ...}: {
  cfg.commands.editor.package = pkgs.nvim;
  home.packages = with pkgs; [
    nvim
    neovide
  ];
}
