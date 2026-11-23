{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  user = config.cfg.user.name;
  secretsDir = ../../secrets;
  has = name: builtins.pathExists (secretsDir + "/${name}.age");
in {
  imports = [inputs.agenix.nixosModules.default];

  environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default];

  # one shared passphrase-less key, copied to every machine by hand:
  #   sudo install -d -m 700 /var/lib/agenix
  #   sudo install -m 600 <private key> /var/lib/agenix/key
  age.identityPaths = ["/var/lib/agenix/key"];

  # secrets are only declared once the encrypted file exists, so this
  # module is inert until you run `agenix -e` (see secrets/agenix-rules.nix)
  age.secrets = lib.mkMerge [
    (lib.mkIf (has "${user}-password") {
      "${user}-password".file = secretsDir + "/${user}-password.age";
    })
    # secret name suffix -> file name under ~/.ssh
    (lib.mkMerge (lib.mapAttrsToList (suffix: file:
      lib.mkIf (has "${user}-${suffix}" && builtins.elem suffix config.cfg.host.userSshKeys) {
        "${user}-${suffix}" = {
          file = secretsDir + "/${user}-${suffix}.age";
          path = "/home/${user}/.ssh/${file}";
          owner = user;
          mode = "0600";
        };
      }) {
      ssh-git = "git";
      ssh-oracle = "ssh-key-oracle";
    }))
  ];

  # generate the hash with: mkpasswd -m yescrypt
  users.users.${user} = lib.mkIf (has "${user}-password") {
    hashedPasswordFile = config.age.secrets."${user}-password".path;
    initialPassword = lib.mkForce null;
  };
}
