{ hostname
, pkgs
, userConfig
, ...
}: let
  key = if hostname == "omnibook"
    then "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtlDkVL/0TH2zsD+nSawpwChiXH9QYkDXXxtaNtji5g"
    else "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRbsrBxvy3bBKMzRZkYvbSld4PHlr6tDzipcy0On6XX";
in {
  imports = [ ./ssh.nix ./gpg.nix ];

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      signing = {
        key = "${key} ${userConfig.email}";
        signByDefault = true;
      };
      settings = {
        user = {
          name = userConfig.fullName;
          email = userConfig.email;
        };
        pull.rebase = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "/home/${userConfig.name}/.config/git/allowed_signers";
        credential.helper = "${pkgs.git.override {withLibsecret = true;}}/libexec/git-core/git-credential-libsecret";

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
  };

  home.file.".config/git/allowed_signers".text = ''${userConfig.email} ${key}'';
}
