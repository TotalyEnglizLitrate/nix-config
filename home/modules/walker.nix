{...}: {
  programs.walker = {
    enable = true;
    config = {
      terminal = "foot";
      providers.default = [
        "calc"
        "desktopapplications"
        "runner"
        "websearch"
      ];
      providers.empty = ["desktopapplications"];
      providers.prefixes = [
        {
          prefix = ":";
          provider = "providerList";
        }

        {
          prefix = "/";
          provider = "files";
        }

        {
          prefix = ".";
          provider = "symbols";
        }

        {
          prefix = ">";
          provider = "runner";
        }

        {
          prefix = "?";
          provider = "websearch";
        }

        {
          prefix = "=";
          provider = "calc";
        }
      ];
    };
  };
}
