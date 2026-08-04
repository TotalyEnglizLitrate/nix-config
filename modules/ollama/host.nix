{pkgs, ...}: {
  # services.ollama = {
  #   enable = true;
  #   rocmOverrideGfx = "11.5.1";
  #   package = pkgs.ollama-rocm;
  # };

  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-rocm;
  };

  environment = {
    systemPackages = with pkgs; [
      goose-cli
      llama-cpp-rocm
    ];

    variables.HSA_OVERRIDE_GFX_VERSION = "'11.5.0'";
  };
}
