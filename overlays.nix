{inputs, ...}: let
  getSystem = final: final.stdenv.hostPlatform.system;
in {
  spotify = final: _prev: {spotify = final.callPackage ./pkgs/spotify {};};
  nvim = final: _prev: {inherit (inputs.nvim.packages.${getSystem final}) nvim;};
  helium = final: _prev: {helium = inputs.helium-browser.packages.${getSystem final}.default;};
  toad = final: _prev: {toad = inputs.toad.packages.${getSystem final}.default;};
}
