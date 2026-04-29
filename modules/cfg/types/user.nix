{lib}:
with lib.types; {
  userType = submodule {
    options = {
      name = lib.mkOption {
        type = str;
        description = "Unix username";
      };
      fullName = lib.mkOption {
        type = str;
        default = "";
      };
      email = lib.mkOption {
        type = str;
        default = "";
      };
      shell = lib.mkOption {
        type = str;
        default = "fish";
      };
    };
  };
}
