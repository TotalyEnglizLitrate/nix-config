{userConfig, ...}: {
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

      plugins = [
        {
          name = "wallpapers";
          prefix = ";w";
          src_once = "ls /home/${userConfig.name}/Pictures/wallpapers --format single-column | shuf -n 5";
          cmd = "swww img /home/${userConfig.name}/Pictures/wallpapers/%RESULT% && notify-send 'Wallpaper changed' '%RESULT%'";
        }
      ];
    };
  };
}
