{
  lib,
  pkgs,
  cfg,
  ...
}: let
  nixos_config_dir = "/home/${cfg.user.name}/Documents/repositories/nix-config";
in {
  nix.settings = {
    extra-substituters = lib.mkAfter ["https://watersucks.cachix.org"]; # optnix tui cache
    trusted-public-keys = ["watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="];
  };
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
        command = [
          "${pkgs.nvd}/bin/nvd"
          "diff"
        ];
      };
    };
  };

  environment.variables = {
    NIXOS_CONFIG_DIR = nixos_config_dir;
    NIXOS_CONFIG = "${nixos_config_dir}#${cfg.host.hostname}";
  };
}
