{inputs, ...}: {
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };

  spotify = final: _prev: { spotify = final.callPackage ../pkgs/spotify {}; };
}
