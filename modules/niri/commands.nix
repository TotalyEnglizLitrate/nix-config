{
  lib,
  config,
  ...
}: let
  commandType = lib.types.submodule ({config, ...}: {
    options = {
      package = lib.mkOption {type = lib.types.package;};
      binary = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        apply = val:
          if val != null
          then val
          else if config.package ? meta && config.package.meta ? mainProgram
          then config.package.meta.mainProgram
          else throw "commandType.binary: set explicitly or package needs meta.mainProgram";
      };
      args = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };
  });
in {
  options = {
    commands = {
      terminal = lib.mkOption {
        type = commandType;
        description = "Primary terminal emulator";
      };
      browser = lib.mkOption {
        type = commandType;
        description = "Primary web browser";
      };
      editor = lib.mkOption {
        type = commandType;
        description = "Primary text editor";
      };
      fileManager = lib.mkOption {
        type = commandType;
        description = "Primary file manager";
      };
      sysmon = lib.mkOption {
        type = commandType;
        description = "System monitor (e.g. btop)";
      };
    };
    commandsList = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default =
        lib.mapAttrs (
          _: cmd:
            ["${cmd.package}/bin/${cmd.binary}"] ++ cmd.args
        )
        config.commands;
      readOnly = true;
      description = "Derived: each command as a ready-to-use argv list including args";
    };
  };
}
