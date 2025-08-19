{...}: {
  programs.walker = {
    enable = true;
    config = {
      terminal = "foot";
      builtins = {
        calc.prefix = ";c";
        emojis.prefix = ";e";
        symbols.prefix = ";e";
        websearch = {
          prefix = ";/";
          entries = [
            {
              name = "UnDuck";
              url = "https://unduck.link/?q=%TERM%";
            }
          ];
        };
      };
    };
  };
}
