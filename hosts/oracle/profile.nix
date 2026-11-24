_: {
  cfg.host = {
    bluetooth = false;
    # no private ssh keys on a public server
    userSshKeys = [];
    sshConfigSecrets = [];
  };
}
