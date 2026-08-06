{inputs, ...}: let
  getSystem = final: final.stdenv.hostPlatform.system;
in {
  kernelOverlay = final: _prev: {
    kernelOverlay = import inputs.nixpkgs-kernel {
      system = getSystem final;
      config.allowUnfree = true;
    };
  };
  spotify = final: _prev: {spotify = final.callPackage ./pkgs/spotify {};};
  nvim = final: _prev: {inherit (inputs.nvim.packages.${getSystem final}) nvim;};
  helium = final: _prev: {helium = inputs.helium-browser.packages.${getSystem final}.default;};
  niri = inputs.niri-nix.overlays.niri-nix;
  noctalia = inputs.noctalia.overlays.default;
  claude-code = inputs.claude-code.overlays.default;
}
