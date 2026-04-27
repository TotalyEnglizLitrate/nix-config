{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ani-cli
    arrpc
    bibata-cursors
    file-roller
    foliate
    fragments
    kdePackages.okular
    libreoffice-qt6-fresh
    lmstudio
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
    xwayland-satellite-unstable

    inputs.helium-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    chromium
    firefox-devedition
  ];
}
