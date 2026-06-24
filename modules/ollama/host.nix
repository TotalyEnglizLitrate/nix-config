{
  pkgs,
  outputs,
  ...
}: {
  services.ollama = {
    enable = true;
    rocmOverrideGfx = "11.5.1";
    package = pkgs.ollama-rocm;
  };

  nixpkgs.overlays = [outputs.overlays.toad];
  environment.systemPackages = with pkgs; [goose-cli toad];
}
