{lib}:
with lib.types; {
  displayType = submodule {
    options = {
      resolution = lib.mkOption {
        type = nullOr (submodule {
          options = {
            width = lib.mkOption {type = int;};
            height = lib.mkOption {type = int;};
          };
        });
        default = null;
        description = "Null means leave at native/auto";
      };
      refreshRate = lib.mkOption {
        type = nullOr float;
        default = null;
        description = "Hz. Null means auto";
      };
      scale = lib.mkOption {
        type = float;
        default = 1.0;
      };
      variable-refresh-rate = lib.mkOption {
        type = bool;
        default = false;
        description = "Variable refresh rate / adaptive sync";
      };
      position = lib.mkOption {
        type = nullOr (submodule {
          options = {
            x = lib.mkOption {type = int;};
            y = lib.mkOption {type = int;};
          };
        });
        default = null;
        description = "Logical position for multi-monitor setups. Null means auto";
      };
    };
  };
}
