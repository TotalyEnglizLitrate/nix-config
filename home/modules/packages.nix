{pkgs, ...}: {
  home.packages = with pkgs; [
    batmon
    brightnessctl
    claude-code
    eza
    fd
    ffmpeg
    gemini-cli
    openjdk21
    jq
    libqalculate
    lm_sensors
    ncdu
    nix-output-monitor
    whisper-cpp-vulkan
    pandoc
    (texliveFull.withPackages (ps: with ps; [fontawesome6]))
    pipenv
    pulseaudio
    python3
    ripgrep
    ugrep
    unzip
    virtiofsd
    xxd
    yt-dlp
    zoxide
    inetutils
    typst
    typstyle
  ];
}
