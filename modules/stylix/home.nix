{
  lib,
  config,
  ...
}: let
  stylix-kde-theme = lib.findFirst (pkg: pkg.name == "stylix-kde-theme") null config.home.packages;
  schemePath = config.stylix.base16Scheme;
  schemeFileName = lib.removeSuffix ".yaml" (baseNameOf schemePath);
  toPascalCase = str:
    lib.concatMapStrings (word: lib.toUpper (lib.substring 0 1 word) + lib.substring 1 (-1) word) (
      lib.splitString "-" str
    );
  colorFileName = "${toPascalCase schemeFileName}.colors";
in {
  home.file.".config/kdeglobals".source = "${stylix-kde-theme}/share/color-schemes/${colorFileName}"; # kde connect
}
