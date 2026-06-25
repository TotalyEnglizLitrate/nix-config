{
  pkgs,
  outputs,
  ...
}: {
  # services.ollama = {
  #   enable = true;
  #   rocmOverrideGfx = "11.5.1";
  #   package = pkgs.ollama-rocm;
  # };

  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-rocm;
  };

  nixpkgs.overlays = [outputs.overlays.toad];
  environment = {
    systemPackages = with pkgs; [
      goose-cli
      toad
      llama-cpp-rocm
    ];

    variables.HSA_OVERRIDE_GFX_VERSION="'11.5.0'";
  };
}
