{
  config,
  pkgs,
  userConfig,
  ...
}: let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtlDkVL/0TH2zsD+nSawpwChiXH9QYkDXXxtaNtji5g"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRbsrBxvy3bBKMzRZkYvbSld4PHlr6tDzipcy0On6XX" # secondary key made ad-hoc; keeping it around
  ];
  key = builtins.elemAt keys 0;
  signersFile = ".config/git/allowed_signers";
in {
  imports = [
    ../ssh.nix
    ./gpg.nix
  ];
  home.file.${signersFile}.text = "${userConfig.email} ${key}";

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      signing = {
        key = "${key} ${userConfig.email}";
        signByDefault = true;
        format = null;
      };
      settings = {
        user = {
          name = userConfig.fullName;
          inherit (userConfig) email;
        };
        pull.rebase = true;
        push.followTags = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = config.home.file.${signersFile}.target;
        credential.helper = "${
          pkgs.git.override {withLibsecret = true;}
        }/libexec/git-core/git-credential-libsecret";
      };
    };

    delta = {
      enable = true;
      options = {
        keep-plus-minus-markers = true;
        light = false;
        line-numbers = true;
        navigate = true;
        width = 280;
      };
    };

    lazygit = {
      enable = true;

      settings = {
        git = {
          pagers = [
            {pager = "delta --color-only --dark --paging=never";}
          ];
        };
      };
    };
  };
}
