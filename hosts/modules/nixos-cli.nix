{
  pkgs,
  hostname,
  ...
}: {
  programs.nixos-cli = {
    enable = true;
    option-cache.enable = true;
    settings = {
      apply = {
        ignore_dirty_tree = true;
        use_nom = true;
        reexec_as_root = true;
      };
      differ = {
        tool = "command";
        command = ["${pkgs.nvd}/bin/nvd" "diff"];
      };
    };
  };

  environment.variables.NIXOS_CONFIG = "self#${hostname}";
}
