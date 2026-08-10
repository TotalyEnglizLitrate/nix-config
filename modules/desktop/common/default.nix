{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./commands.nix
    ./gtk.nix
    ./kanshi.nix
    ./packages.nix
    ./spotify.nix
    ./terminal.nix
    ./xdg.nix
    ../noctalia/home
  ];

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  home.sessionVariables = {
    EDITOR = config.commands.editor.binary;
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      "default-folder-viewer" = "grid-view";
      "migrated-gtk-settings" = true;
      "search-filter-time-type" = "last_modified";
      "search-view" = "list-view";
    };

    "org/gtk/settings/file-chooser" = {
      "date-format" = "regular";
      "location-mode" = "path-bar";
      "show-size-column" = true;
      "show-type-column" = true;
      "sort-column" = "name";
      "sort-directories-first" = true;
      "sort-order" = "ascending";
      "type-format" = "category";
      "view-type" = "grid";
    };
  };
}
