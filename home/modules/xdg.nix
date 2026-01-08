{...}: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "audio/mpeg" = ["vlc.desktop"];
        "application/pdf" = ["okular.desktop"];
        "image/*" = ["org.gnome.Loupe.desktop"];
        "video/*" = ["vlc.desktop"];
        "audio/*" = ["vlc.desktop"];
      };
      defaultApplications = {
        "application/json" = ["gnome-text-editor.desktop"];
        "application/toml" = "org.gnome.TextEditor.desktop";
        "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
        "application/pdf" = ["okular.desktop"];
        "audio/*" = ["vlc.desktop"];
        "image/*" = ["org.gnome.loupe.desktop"];
        "video/*" = ["vlc.desktop"];
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
