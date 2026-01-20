{...}: {
  programs.bluetuith = {
    enable = true;
    settings = {
      keybindings = {
        Help = "?";
        Quit = "q";
      };
    };
  };
}
