{
  lib,
  callPackage,
  ...
} @ args: let
  extraArgs = removeAttrs args ["callPackage"];

  pname = "spotify";

  updateScript = ./update.sh;

  meta = {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "spotify";
  };
in
  callPackage ./linux.nix (extraArgs // {inherit pname updateScript meta;})
