{pkgs, ...}: {
  # Ensure Telegram desktop package installed
  home.packages = with pkgs; [
    telegram-desktop
  ];

  xdg = {
    mimeApps = {
      associations.added = {
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "x-scheme-handler/tonsite" = ["org.telegram.desktop.desktop"];
      };
      defaultApplications = {
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "x-scheme-handler/tonsite" = ["org.telegram.desktop.desktop"];
      };
    };
  };
}
