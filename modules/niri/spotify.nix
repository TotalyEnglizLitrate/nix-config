{
  inputs,
  outputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  nixpkgs.overlays = [outputs.overlays.spotify];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
      adblock
      beautifulLyrics
    ];
    spotifyPackage = pkgs.spotify;
    wayland = true;
    windowManagerPatch = true;
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
