{
  hostname,
  userConfig,
  ...
}: let
  flakePath = "/home/${userConfig.name}/Documents/repositories/nix-config";
in {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
  environment.sessionVariables = {
    NH_OS_FLAKE = "${flakePath}/#nixosConfigurations.${hostname}";
    NH_HOME_FLAKE = "${flakePath}/#homeConfigurations.${userConfig.name}@${hostname}";
  };
}
