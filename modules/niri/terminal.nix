{lib, ...}: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings.font-size = lib.mkForce 16;
  };
}
