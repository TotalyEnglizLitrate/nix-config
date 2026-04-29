{
  lib,
  config,
  ...
}: let
  inherit (import ./types {inherit lib;}) userType hostType;
in {
  options.cfg = {
    user = lib.mkOption {
      type = userType;
      description = "Primary user of this machine";
    };

    host = lib.mkOption {
      type = hostType;
      description = "Hardware and display metadata for this machine";
    };
  };

  config._module.args.cfg = config.cfg;
}
