{inputs, ...}: let
  getSystem = final: final.stdenv.hostPlatform.system;
in {
  spotify = final: _prev: {spotify = final.callPackage ./pkgs/spotify {};};
  nvim = final: _prev: {inherit (inputs.nvim.packages.${getSystem final}) nvim;};
  helium = final: _prev: {helium = inputs.helium-browser.packages.${getSystem final}.default;};
  nixcu = final: _prev: {nixcu = inputs.nixcu.packages.${getSystem final}.default;};
  ncr = final: _prev: {ncr = inputs.ncr.packages.${getSystem final}.default;};
  anywayd = final: _prev: {anywayd = inputs.anywayd.packages.${getSystem final}.default;};
  niri = inputs.niri-nix.overlays.niri-nix;
  mango = inputs.mangowc.overlays.default;
  noctalia = inputs.noctalia.overlays.default;
  umbriel = final: _prev: let
    system = getSystem final;
  in {
    umbriel = inputs.umbriel.packages.${system}.default;
    umbriel-desktop-portal = inputs.umbriel-desktop-portal.packages.${system}.default;
  };
  claude-code = inputs.claude-code.overlays.default;
}
