{inputs, ...}: let
  getSystem = final: final.stdenv.hostPlatform.system;
in {
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = getSystem final;
      config.allowUnfree = true;
    };
  };

  spotify = final: _prev: {spotify = final.callPackage ./pkgs/spotify {};};
  nvim = final: _prev: {nvim = inputs.nvim.packages.${getSystem final}.nvim;};
  helium = final: _prev: {helium = inputs.helium-browser.packages.${getSystem final}.default;};
}
