{lib, ...}: {
  imports = [./browser.nix];
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "video/*" = ["vlc.desktop"];
        "audio/*" = ["vlc.desktop"];
      };
      defaultApplications = {
        "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
        "application/pdf" = lib.mkBefore ["okularApplication_pdf.desktop"];
        "image/*" = lib.mkBefore ["org.gnome.Loupe.desktop"];
        "audio/*" = ["vlc.desktop"];
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
