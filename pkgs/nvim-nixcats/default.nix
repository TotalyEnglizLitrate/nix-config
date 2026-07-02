{
  pkgs ? import <nixpkgs> {},
  nixCats ? throw "nixCats input is required",
  treesitter-textobjects ? throw "treesitter-textobjects input is required",
  org-bullets ? throw "org-bullets input is required",
  copilot-chat ? throw "copilot-chat input is required",
  juno ? throw "juno input is required",
  otter-nvim ? throw "otter-nvim input is required",
  ...
}: let
  # get the nixCats library with the builder function (and everything else) in it
  utils = import nixCats;
  # path to your new .config/nvim
  luaPath = ./.;

  # see :help nixCats.flake.outputs.categories
  categoryDefinitions = {
    pkgs,
    settings,
    categories,
    extra,
    name,
    mkPlugin,
    ...
  } @ packageDef: {
    lspsAndRuntimeDeps = {
      general = with pkgs; [
        lazygit
        lua-language-server
        stylua
        tree-sitter
        nixd
        alejandra
        rust-analyzer
        basedpyright
        clang-tools
        dart
        gopls
        go
        nodejs
        pnpm
        typescript
        typescript-language-server
        typst
        tinymist
        typos-lsp
        black
        markdown-oxide
        (texliveFull.withPackages (ps: with ps; [fontawesome6]))
      ];
    };

    # This is for plugins that will load at startup without using packadd:
    startupPlugins = {
      general = with pkgs.vimPlugins; [
        snacks-nvim
        tokyonight-nvim
        orgmode
        (mkPlugin "org-bullets" org-bullets)
        (mkPlugin "juno" juno)
        (mkPlugin "otter-nvim" otter-nvim)
        comment-nvim
        vim-sleuth
        mini-ai
        mini-icons
        mini-pairs
        render-markdown-nvim
        nvim-lspconfig
        vim-startuptime
        blink-cmp
        nvim-treesitter.withAllGrammars
        (mkPlugin "treesitter-textobjects" treesitter-textobjects)
        copilot-lua
        (mkPlugin "copilot-chat" copilot-chat)
        plenary-nvim
        lualine-nvim
        lualine-lsp-progress
        bufferline-nvim
        noice-nvim
        gitsigns-nvim
        which-key-nvim
        nvim-lint
        conform-nvim
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        cord-nvim
        nvim-web-devicons
      ];
    };

    # not loaded automatically at startup.
    # use with packadd and an autocommand in config to achieve lazy loading
    optionalPlugins = {
      general = with pkgs.vimPlugins; [
        lazydev-nvim
      ];
    };
  };

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    # These are the names of your packages
    # you can include as many as you wish.
    # each of these sets are also written into the nixCats plugin for querying within lua.
    nvim = {
      pkgs,
      name,
      mkPlugin,
      ...
    }: {
      settings = {
        suffix-path = true;
        suffix-LD = true;
        # see :help nixCats.flake.outputs.settings
        # IMPORTANT:
        # your aliases may not conflict with other packages.
        # aliases = [ "vim" ];
        hosts.python3.enable = false;
        hosts.node.enable = false;
        hosts.ruby.enable = false;
        hosts.perl.enable = false;
      };
      # and a set of categories that you want
      # All categories you wish to include must be marked true
      categories = {
        general = true;
      };
      # anything else to pass and grab in lua with `nixCats.extra`
      extra = {};
    };
  };

  # We will build the one named nvim here and export that one.
  defaultPackageName = "nvim";

  # return our package!
  nvim =
    (utils.baseBuilder luaPath {inherit pkgs;} categoryDefinitions packageDefinitions defaultPackageName)
    // {
      pname = defaultPackageName;
      version = pkgs.neovim.version;
    };
in {
  inherit nvim;
}
