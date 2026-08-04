{pkgs, ...}: {
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-rocm;
  };

  environment = {
    systemPackages = with pkgs; [llama-cpp-rocm];

    variables.HSA_OVERRIDE_GFX_VERSION = "11.5.1";
  };
}
