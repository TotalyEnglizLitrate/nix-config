{lib, config, ...}: let
  userType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Unix username";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      shell = lib.mkOption {
        type = lib.types.str;
        default = "fish";
      };
    };
  };

  displayType = lib.types.submodule {
    options = {
      resolution = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            width = lib.mkOption {type = lib.types.int;};
            height = lib.mkOption {type = lib.types.int;};
          };
        });
        default = null;
        description = "Null means leave at native/auto";
      };
      refreshRate = lib.mkOption {
        type = lib.types.nullOr lib.types.float;
        default = null;
        description = "Hz. Null means auto";
      };
      scale = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
      };
      variable-refresh-rate = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Variable refresh rate / adaptive sync";
      };
      position = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            x = lib.mkOption {type = lib.types.int;};
            y = lib.mkOption {type = lib.types.int;};
          };
        });
        default = null;
        description = "Logical position for multi-monitor setups. Null means auto";
      };
    };
  };

  hostType = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "Machine hostname";
      };

      displays = lib.mkOption {
        type = lib.types.attrsOf displayType;
        default = {};
        description = "Connected displays and their properties";
      };

      gpu = {
        amd = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable ROCm support (AMD compute)";
        };

        # no-op: to be implemented if I ever get a machine with a NVIDIA card
        nvidia = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Nvidia drivers and CUDA";
        };
      };

      fprint = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the machine has a fingerprint reader";
      };

      webcam = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the machine has a webcam";
      };

      bluetooth = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      laptop = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables laptop-specific config (lid events, touchpad, backlight etc.)";
      };
    };
  };
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
}
