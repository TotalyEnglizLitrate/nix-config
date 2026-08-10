{
  outputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    outputs.overlays.nvim
    outputs.overlays.claude-code
    outputs.overlays.nixcu
  ];
  home.packages = with pkgs; [
    batmon
    brightnessctl
    claude-code
    claude-agent-acp
    ffmpeg
    openjdk21
    libqalculate
    lm_sensors
    ncdu
    nix-output-monitor
    nixcu
    whisper-cpp-vulkan
    pandoc
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
    tack
  ];
}
