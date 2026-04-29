{lib}: let
  inherit ((import ./display.nix {inherit lib;})) displayType;
in
  with lib.types; {
    hostType = submodule {
      options = {
        hostname = lib.mkOption {
          type = str;
          description = "Machine hostname";
        };

        displays = lib.mkOption {
          type = attrsOf displayType;
          default = {};
          description = "Connected displays and their properties";
        };

        gpu = {
          amd = lib.mkOption {
            type = bool;
            default = false;
            description = "Enable ROCm support (AMD compute)";
          };

          # no-op: to be implemented if I ever get a machine with a NVIDIA card
          nvidia = lib.mkOption {
            type = bool;
            default = false;
            description = "Enable Nvidia drivers and CUDA";
          };
        };

        fprint = lib.mkOption {
          type = bool;
          default = false;
          description = "Whether the machine has a fingerprint reader";
        };

        webcam = lib.mkOption {
          type = bool;
          default = false;
          description = "Whether the machine has a webcam";
        };

        bluetooth = lib.mkOption {
          type = bool;
          default = true;
        };

        laptop = lib.mkOption {
          type = bool;
          default = false;
          description = "Enables laptop-specific config (lid events, touchpad, backlight etc.)";
        };
      };
    };
  }
