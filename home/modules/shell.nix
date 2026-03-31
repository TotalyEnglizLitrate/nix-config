_: {
  programs = {
    bat.enable = true;

    fzf = {
      enable = true;
      defaultCommand = "find .";
      defaultOptions = [
        "--bind '?:toggle-preview'"
        "--bind 'ctrl-a:select-all'"
        "--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'"
        "--bind 'ctrl-y:execute-silent(echo {+} | wl-copy)'"
        "--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
        "--height=40%"
        "--info=inline"
        "--layout=reverse"
        "--multi"
        "--preview '([[ -f {}  ]] && (bat --color=always --style=numbers,changes {} || cat {})) || ([[ -d {}  ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
        "--preview-window=:hidden"
        "--prompt='~ ' --pointer='▶' --marker='✓'"
      ];
    };
  };

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
      cd = "z";
      "..." = "../../";
    };
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
}
