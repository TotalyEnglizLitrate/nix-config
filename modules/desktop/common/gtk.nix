{
  config,
  osConfig ? null,
  lib,
  ...
}: let
  isStandalone = osConfig == null;
  contains = target: seq: (lib.lists.any (x: x == target) seq);
in {
  gtk = {
    enable = true;
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;

      bookmarks = let
        needsAdmin = ["/boot"];
      in (map (p:
        if (contains p needsAdmin)
        then "admin://${p}"
        else "file://${p}") (
        map (p: "${config.home.homeDirectory}/${p}") [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          "Documents/repos"
        ]
        ++ lib.optionals (!isStandalone) (builtins.attrNames osConfig.fileSystems)
      ));
    };

    gtk4.theme = lib.mkForce null;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };
}
