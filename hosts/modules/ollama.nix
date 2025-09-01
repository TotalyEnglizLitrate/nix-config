{pkgs, ...}: {
  environment.systemPackages = with pkgs; [ollama ollama-rocm];
  services.ollama = {
    enable = true;
  };
}
