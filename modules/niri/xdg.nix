_: {
  imports = [./browser.nix];
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "audio/mpeg" = ["vlc.desktop"];
        "video/*" = ["vlc.desktop"];
        "audio/*" = ["vlc.desktop"];
      };
      defaultApplications = {
        "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
        "audio/*" = ["vlc.desktop"];
        "image/*" = ["org.gnome.loupe.desktop"];
        "video/*" = ["vlc.desktop"];
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };
}
