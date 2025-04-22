{...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "eza";
      dir = "eza";
      cat = "bat";
    };
    interactiveShellInit = ''
      set fish_greeting
      if not set -q TMUX
        tmux attach || tmux
      end
    '';
  };
}
