{
  pkgs,
  userConfig,
  hostname,
  ...
}: let
  nixos_config_dir = "/home/${userConfig.name}/Documents/repositories/nix-config";
in {
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

  environment.variables = {
    NIXOS_CONFIG_DIR = nixos_config_dir;
    NIXOS_CONFIG = "${nixos_config_dir}#${hostname}";
  };
}
