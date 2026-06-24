{pkgs, ...} : {
  services.ollama = {
    enable = true;
    rocmOverrideGfx = "11.5.1";
    package = pkgs.ollama-rocm;
  };

  environment.systemPackages = [ pkgs.toad ];
}
