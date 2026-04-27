{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
      adblock
      beautifulLyrics
    ];
    spotifyPackage = pkgs.callPackage ../../../pkgs/spotify {};
  };

  xdg = {
    mimeApps = {
      associations.added = {
        "x-scheme-handler/spotify" = ["spotify.desktop"];
      };
      defaultApplications = {
        "x-scheme-handler/spotify" = ["spotify.desktop"];
      };
    };
  };
}
