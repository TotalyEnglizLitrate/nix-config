{pkgs, ...}: {
  home.packages = with pkgs; [
    batmon
    brightnessctl
    claude-code
    claude-agent-acp
    ffmpeg
    gemini-cli
    openjdk21
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
    unzip
    virtiofsd
    xxd
    inetutils
    typst
    typstyle
    ugrep
  ];
}
