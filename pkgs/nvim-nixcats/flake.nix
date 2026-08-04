{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  # `tack init` populates ./.tack with your pins
  outputs = {self, ...} @ args: let
    inputs = (import ./.tack) {overrides = args.tackOverrides or {};};
    inherit (inputs.nixCats) utils;
    inherit (inputs) nixpkgs;
    luaPath = ./.;
    forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
  in {
    packages = forEachSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };
    in
      import ./default.nix (inputs // {inherit pkgs;}));

    devShells = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [nixd];
      };
    });
  };
}
