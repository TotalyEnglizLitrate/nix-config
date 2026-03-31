_: {
  programs.nixos-cli = {
    enable = true;
    option-cache.enable = true;
    settings = {
      use_nvd = true;
      apply = {
        ignore_dirty_tree = true;
        use_nom = true;
      };
    };
  };
}
