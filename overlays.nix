{inputs, ...}: let
  getSystem = final: final.stdenv.hostPlatform.system;
in {
  stableOverlay = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = getSystem final;
      config.allowUnfree = true;
    };
  };
  spotify = final: _prev: {spotify = final.callPackage ./pkgs/spotify {};};
  nvim = final: _prev: {inherit (inputs.nvim.packages.${getSystem final}) nvim;};
  helium = final: _prev: {helium = inputs.helium-browser.packages.${getSystem final}.default;};
  nixcu = final: _prev: {nixcu = inputs.nixcu.packages.${getSystem final}.default;};
  ncr = final: _prev: {ncr = inputs.ncr.packages.${getSystem final}.default;};
  anywayd = final: _prev: {anywayd = inputs.anywayd.packages.${getSystem final}.default;};
  niri = inputs.niri-nix.overlays.niri-nix;
  claude-code = inputs.claude-code.overlays.default;
  pam-fprint-grosshack = final: prev: {pam-fprint-grosshack = final.callPackage ./pkgs/pam_fprint_grosshack/package.nix {};};
  seekey = final: prev: {seekey = final.callPackage ./pkgs/seekey/package.nix {};};
}
