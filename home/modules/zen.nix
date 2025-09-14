{
  pkgs,
  inputs,
  lib,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      inputs.zen-browser.packages."${system}".twilight
    ];
    xdg = {
      mimeApps = {
        defaultApplications = lib.mkMerge [
          {
            "application/x-extension-htm" = "zen.desktop";
            "application/x-extension-html" = "zen.desktop";
            "application/x-extension-shtml" = "zen.desktop";
            "application/x-extension-xht" = "zen.desktop";
            "application/x-extension-xhtml" = "zen.desktop";
            "application/xhtml+xml" = "zen.desktop";
            "text/html" = "zen.desktop";
            "x-scheme-handler/about" = "zen.desktop";
            "x-scheme-handler/ftp" = "zen.desktop";
            "x-scheme-handler/http" = "zen.desktop";
            "x-scheme-handler/https" = "zen.desktop";
            "x-scheme-handler/unknown" = "zen.desktop";
            "application/pdf" = "zen.desktop";
          }
        ];
      };
    };
  };
}
