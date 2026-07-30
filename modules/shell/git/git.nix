{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  signingKeys = osConfig.cfg.user.signingKeys;
  hasSigningKeys = signingKeys != [];
  key =
    if hasSigningKeys
    then builtins.elemAt signingKeys 0
    else null;
  signersFile = ".config/git/allowed_signers";
  pubKeyFile = ".ssh/git.pub";
in {
  imports = [
    ../ssh.nix
    ./gpg.nix
  ];

  home.file = lib.mkIf hasSigningKeys (
    lib.genAttrs [signersFile pubKeyFile]
    (_: {text = "${key} ${osConfig.cfg.user.email}";})
  );

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      signing = lib.mkIf hasSigningKeys {
        key = "~/${config.home.file.${pubKeyFile}.target}";
        signByDefault = true;
        format = "ssh";
      };
      settings = {
        user = with osConfig.cfg.user; {
          name = fullName;
          inherit email;
        };
        pull.rebase = true;
        push.followTags = true;
        gpg = lib.mkIf hasSigningKeys {
          format = "ssh";
          ssh.allowedSignersFile = "~/${config.home.file.${signersFile}.target}";
        };
        credential.helper = "${
          pkgs.git.override {withLibsecret = true;}
        }/libexec/git-core/git-credential-libsecret";
        advice.defaultBranchName = false;
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
