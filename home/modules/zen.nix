{
  pkgs,
  inputs,
  ...
}: {
  config = {
    # Ensure zen browser package installed
    home.packages = with pkgs; [
      inputs.zen-browser.packages."${system}".default
    ];

    # Ensure XDG browser settings are in place
    xdg = {
      mimeApps = {
        defaultApplications = {
          "application/x-extension-htm" = "zen.desktop";
          "application/x-extension-html" = "zen.desktop";
          "application/x-extension-shtml" = "zen.desktop";
          "application/x-extension-xht" = "zen.desktop";
          "application/x-extension-xhtml" = "zen.desktop";
          "application/xhtml+xml" = "zen.desktop";
          "text/html" = "zen.desktop";
          "x-scheme-handler/about" = "zen.desktop";
          "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
          "x-scheme-handler/ftp" = "zen.desktop";
          "x-scheme-handler/http" = "zen.desktop";
          "x-scheme-handler/https" = "zen.desktop";
          "x-scheme-handler/unknown" = "zen.desktop";

          "application/pdf" = "zen.desktop";
        };
      };
    };
  };
}
