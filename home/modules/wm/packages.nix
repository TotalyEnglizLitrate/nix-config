{inputs, pkgs, ...}: {
  home.packages = with pkgs; [
    ani-cli
    arrpc
    bibata-cursors
    gnome-keyring
    file-roller
    foliate
    fragments
    kdePackages.kdeconnect-kde
    kdePackages.okular
    libreoffice-qt6-fresh
    lmstudio
    localsend
    loupe
    nautilus
    obsidian
    pavucontrol
    playerctl
    qpwgraph
    remmina
    seahorse
    swww
    syncplay
    tesseract
    vlc
    wl-clipboard
    wlr-randr
    xournalpp
    xwayland-satellite-unstable

    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
  ];
}
