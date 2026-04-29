{
  lib,
  config,
  ...
}: let
  inherit (import ./types/command.nix {inherit lib;}) commandType;
in {
  options.cfg = {
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
      noctalia = lib.mkOption {
        type = commandType;
        description = "Noctalia shell";
      };
    };
    commandsList = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = let
        inherit (config.cfg.commands) noctalia;
        noctaliaCommand = ["${noctalia.package}/bin/${noctalia.binary}"];
      in
        (lib.mapAttrs (
            _: cmd:
              ["${cmd.package}/bin/${cmd.binary}"] ++ cmd.args
          )
          config.cfg.commands)
        // {noctaliaIPC = noctaliaCommand ++ ["ipc" "call"];};
      readOnly = true;
      description = "Derived: each command as a ready-to-use argv list including args";
    };
  };

  config._module.args = {
    cmds = config.cfg.commands;
    cmdsList = config.cfg.commandsList;
  };
}
