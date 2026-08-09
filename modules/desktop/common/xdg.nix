{lib, ...}: let
  mkAssociations = app: types: lib.genAttrs types (_: lib.mkBefore [app]);

  browserTypes = [
    "application/json"
    "application/rdf+xml"
    "application/rss+xml"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xht"
    "application/x-extension-xhtml"
    "application/xhtml+xml"
    "application/xml"
    "text/html"
    "text/plain"
    "x-scheme-handler/about"
    "x-scheme-handler/chrome"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/mailto"
    "x-scheme-handler/unknown"
  ];

  imageTypes = [
    "image/apng"
    "image/avif"
    "image/bmp"
    "image/gif"
    "image/heic"
    "image/jp2"
    "image/jpeg"
    "image/jxl"
    "image/png"
    "image/qoi"
    "image/svg+xml"
    "image/svg+xml-compressed"
    "image/tiff"
    "image/vnd.microsoft.icon"
    "image/webp"
    "image/x-dds"
    "image/x-exr"
    "image/x-portable-anymap"
    "image/x-portable-bitmap"
    "image/x-portable-graymap"
    "image/x-portable-pixmap"
    "image/x-qoi"
    "image/x-tga"
    "image/x-win-bitmap"
    "image/x-xbitmap"
    "image/x-xpixmap"
  ];

  audioTypes = [
    "audio/aac"
    "audio/ac3"
    "audio/flac"
    "audio/m4a"
    "audio/midi"
    "audio/mp4"
    "audio/mpeg"
    "audio/mpegurl"
    "audio/ogg"
    "audio/opus"
    "audio/vorbis"
    "audio/wav"
    "audio/webm"
    "audio/x-aiff"
    "audio/x-flac"
    "audio/x-m4a"
    "audio/x-matroska"
    "audio/x-mpegurl"
    "audio/x-ms-wma"
    "audio/x-vorbis+ogg"
    "audio/x-wav"
  ];

  videoTypes = [
    "video/3gpp"
    "video/avi"
    "video/mp2t"
    "video/mp4"
    "video/mpeg"
    "video/ogg"
    "video/quicktime"
    "video/webm"
    "video/x-avi"
    "video/x-flv"
    "video/x-m4v"
    "video/x-matroska"
    "video/x-ms-asf"
    "video/x-ms-wmv"
    "video/x-msvideo"
    "video/x-ogm+ogg"
    "video/x-theora+ogg"
  ];

  mediaTypes = audioTypes ++ videoTypes;
in {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications =
        {
          "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
          "application/pdf" = lib.mkBefore ["okularApplication_pdf.desktop"];
        }
        // mkAssociations "helium.desktop" browserTypes
        // mkAssociations "org.gnome.Loupe.desktop" imageTypes
        // mkAssociations "vlc.desktop" mediaTypes;
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };
}
