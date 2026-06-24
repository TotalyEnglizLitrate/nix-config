{pkgs, ...}: {
  home.packages = with pkgs; [
    ani-cli
    arrpc
    bibata-cursors
    file-roller
    foliate
    fragments
    kdePackages.okular
    libreoffice-qt6-fresh
    localsend
    loupe
    nautilus
    obsidian
    pamixer
    pavucontrol
    playerctl
    qpwgraph
    remmina
    seahorse
    syncplay
    vlc
    wl-clipboard
    wlr-randr
    xournalpp

    helium
    chromium
    firefox-devedition
  ];

  commands = {
    browser.package = pkgs.helium;
    fileManager.package = pkgs.nautilus;
  };
}
