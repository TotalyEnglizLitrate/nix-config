{pkgs, ...}: let
in {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs.zellij;
  };
}
