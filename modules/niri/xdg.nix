_: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "audio/mpeg" = ["vlc.desktop"];
        "application/pdf" = ["helium.desktop"];
        "image/*" = ["org.gnome.Loupe.desktop"];
        "video/*" = ["vlc.desktop"];
        "audio/*" = ["vlc.desktop"];
        "application/x-extension-htm" = ["helium.desktop"];
        "application/x-extension-html" = ["helium.desktop"];
        "application/x-extension-shtml" = ["helium.desktop"];
        "application/x-extension-xht" = ["helium.desktop"];
        "application/x-extension-xhtml" = ["helium.desktop"];
        "application/xhtml+xml" = ["helium.desktop"];
        "text/html" = ["helium.desktop"];
        "x-scheme-handler/about" = ["helium.desktop"];
        "x-scheme-handler/ftp" = ["helium.desktop"];
        "x-scheme-handler/http" = ["helium.desktop"];
        "x-scheme-handler/https" = ["helium.desktop"];
        "x-scheme-handler/unknown" = ["helium.desktop"];
      };
      defaultApplications = {
        "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
        "application/pdf" = ["helium.desktop"];
        "audio/*" = ["vlc.desktop"];
        "image/*" = ["org.gnome.loupe.desktop"];
        "video/*" = ["vlc.desktop"];

        "application/x-extension-htm" = "helium.desktop";
        "application/x-extension-html" = "helium.desktop";
        "application/x-extension-shtml" = "helium.desktop";
        "application/x-extension-xht" = "helium.desktop";
        "application/x-extension-xhtml" = "helium.desktop";
        "application/xhtml+xml" = "helium.desktop";
        "text/html" = "helium.desktop";
        "x-scheme-handler/about" = "helium.desktop";
        "x-scheme-handler/ftp" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
        "x-scheme-handler/unknown" = "helium.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };
}
