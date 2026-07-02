{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
      flake = false;
    };
    org-bullets = {
      url = "github:nvim-orgmode/org-bullets.nvim";
      flake = false;
    };
    copilot-chat = {
      url = "github:CopilotC-Nvim/CopilotChat.nvim";
      flake = false;
    };
    juno = {
      url = "github:TotalyEnglizLitrate/juno.nvim";
      flake = false;
    };
    otter-nvim = {
      url = "github:jmbuhr/otter.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
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
