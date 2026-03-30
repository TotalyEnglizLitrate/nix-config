{...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --group-directories-first";
      dir = "eza --group-directories-first";
      ll = "eza -l --group-directories-first";
      la = "eza -lA --group-directories-first";
      tree = "eza --tree --group-directories-first";
      cat = "bat";
      grep = "ugrep";
      "..." = "../../";
    };
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
}
