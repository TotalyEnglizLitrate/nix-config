{lib, ...}: {
  programs.foot = {
    server.enable = true;
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "JetBrainsMonoNL Nerd Font:size=8";
        dpi-aware = lib.mkForce "yes";
      };
      colors.alpha = lib.mkForce 0.7;
    };
  };
}
