{...}: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "audio/mpeg" = ["vlc.desktop"];
        "image/jpeg" = ["org.gnome.Loupe.desktop"];
        "image/jpg" = ["org.gnome.Loupe.desktop"];
        "image/png" = ["org.gnome.Loupe.desktop"];
        "video/mp3" = ["vlc.desktop"];
        "video/mp4" = ["vlc.desktop"];
        "video/quicktime" = ["vlc.desktop"];
        "video/webm" = ["vlc.desktop"];
      };
      defaultApplications = {
        "application/json" = ["gnome-text-editor.desktop"];
        "application/toml" = "org.gnome.TextEditor.desktop";
        "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
        "audio/*" = ["vlc.desktop"];
        "audio/mp3" = ["vlc.desktop"];
        "image/*" = ["org.gnome.loupe.desktop"];
        "image/jpg" = ["org.gnome.loupe.desktop"];
        "image/png" = ["org.gnome.loupe.desktop"];
        "video/*" = ["vlc.desktop"];
        "video/mp4" = ["vlc.desktop"];
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
