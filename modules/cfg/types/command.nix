{lib}:
with lib.types; {
  commandType = submodule ({config, ...}: {
    options = {
      package = lib.mkOption {type = package;};
      binary = lib.mkOption {
        type = nullOr str;
        default = null;
        apply = val:
          if val != null
          then val
          else if config.package ? meta && config.package.meta ? mainProgram
          then config.package.meta.mainProgram
          else throw "commandType.binary: set explicitly or package needs meta.mainProgram";
      };
      args = lib.mkOption {
        type = listOf str;
        default = [];
      };
    };
  });
}
