{userConfig, ...}: {
  imports = [./ssh.nix ./gpg.nix];

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.email;

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

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtlDkVL/0TH2zsD+nSawpwChiXH9QYkDXXxtaNtji5g narendra.s1232@gmail.com";
      signByDefault = true;
    };

    extraConfig = {
      pull.rebase = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "/home/${userConfig.name}/.config/git/allowed_signers";
    };
  };

  home.file.".config/git/allowed_signers".text = ''${userConfig.email} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtlDkVL/0TH2zsD+nSawpwChiXH9QYkDXXxtaNtji5g'';
}
