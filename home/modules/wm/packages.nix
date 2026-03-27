{inputs, pkgs, ...}: {
  home.packages = with pkgs; [
    ani-cli
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
    qpwgraph
    remmina
    seahorse
    swww
    syncplay
    vlc
    xournalpp


    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
  ];
}
