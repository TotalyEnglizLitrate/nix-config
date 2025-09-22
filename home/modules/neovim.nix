{pkgs, ...}: let
  neovim_config = ../../files/configs/nvim;
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      alejandra
      black
      golangci-lint
      gopls
      gotools
      hadolint
      isort
      jdt-language-server
      lua-language-server
      markdownlint-cli
      nixd
      nodePackages.bash-language-server
      nodePackages.prettier
      pyright
      ruff
      shellcheck
      shfmt
      stylua
      terraform-ls
      tflint
      tree-sitter
      vscode-langservers-extracted
      yaml-language-server
      clang-tools
      haskell-language-server
      ghostscript # pdf preview
      zls
    ];
  };

  xdg.configFile = {
    "nvim" = {
      source = "${neovim_config}";
      recursive = true;
    };
  };

  home.file.".config/jdtls".source = "${pkgs.jdt-language-server}";
}
