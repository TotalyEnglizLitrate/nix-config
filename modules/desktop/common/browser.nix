{lib, ...}: {
  xdg.mimeApps = let
    mkAssociations = associations: (builtins.listToAttrs (
      map
      (name: {
        inherit name;
        value = lib.mkBefore ["helium.desktop"];
      })
      associations
    ));

    defaults = [
      "application/x-extension-shtml"
      "application/x-extension-xhtml"
      "application/x-extension-html"
      "application/x-extension-xht"
      "application/x-extension-htm"
      "x-scheme-handler/unknown"
      "x-scheme-handler/mailto"
      "x-scheme-handler/chrome"
      "x-scheme-handler/about"
      "x-scheme-handler/https"
      "x-scheme-handler/http"
      "application/xhtml+xml"
      "application/rdf+xml"
      "application/rss+xml"
      "application/json"
      "application/xml"
      "text/plain"
      "text/html"
    ];

    associations = defaults ++ ["application/pdf"];
  in {
    enable = true;
    associations.added = mkAssociations associations;
    defaultApplications = mkAssociations defaults;
  };
}
