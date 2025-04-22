{pkgs, ...}: {
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Macchiato";
    font.name = "JetBrainsMonoNL Nerd Font";
    font.size = 12;
    extraConfig = ''
      confirm_os_window_close 0
    '';
  };
}
