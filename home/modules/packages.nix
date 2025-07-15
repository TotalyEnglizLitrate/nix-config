{
  pkgs,
  zen-browser,
  ...
}: {
  # ensure common packages are installed
  home.packages = with pkgs;
    [
      batmon
      eza
      fd
      ffmpeg
      ghc
      openjdk21
      jq
      libqalculate
      lm_sensors
      localsend
      ncdu
      nodePackages_latest.nodejs
      ollama
      pipenv
      pulseaudio
      python312Full
      qemu
      qpwgraph
      ripgrep
      rustup
      ugrep
      unzip
      virtiofsd
      xxd
      yt-dlp
      zig
      zoxide
    ]
    ++ [
      zen-browser.packages.${pkgs.system}.twilight
    ];
}
