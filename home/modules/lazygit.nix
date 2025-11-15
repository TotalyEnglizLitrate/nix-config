{ ... }: {
  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        pagers = [
          { pager = "delta --color-only --dark --paging=never"; }
        ];
      };
    };
  };
}
