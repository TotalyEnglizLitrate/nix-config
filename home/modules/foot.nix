{pkgs, ...}: {
  home.packages = with pkgs; [
    foot
  ];

  programs.foot = {
    server.enable = true;
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMonoNL Nerd Font:size=8";
        dpi-aware = "yes";
      };
      colors.alpha = 0.7;
    };
  };
}
