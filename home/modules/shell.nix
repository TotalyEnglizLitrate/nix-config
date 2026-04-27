{lib, ...}: {
  programs =
    {
      bat = {
        enable = true;
        config.style = lib.join "," ["numbers" "changes" "header-filename"];
      };

      fd.enable = true;

      fzf = {
        enable = true;
        enableFishIntegration = true;
        defaultCommand = "fd .";
        defaultOptions = [
          "--bind '?:toggle-preview'"
          "--bind 'ctrl-a:select-all'"
          "--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'"
          "--bind 'ctrl-y:execute-silent(echo {+} | wl-copy)'"
          "--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
          "--border=sharp"
          "--height=40%"
          "--info=inline"
          "--layout=reverse"
          "--multi"
          "--preview 'test -f {} && bat --style=numbers,changes {} || test -d {} && eza --tree {} | less'"
          "--prompt='~ ' --pointer='▶' --marker='✓'"
        ];
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      eza = {
        enable = true;
        colors = "always";
        icons = "always";
        enableFishIntegration = true;
      };

      fish = {
        enable = true;
        shellAliases = {
          cat = "bat";
          cd = "z";
          grep = "ugrep";
          ls = "eza --group-directories-first";
          dir = "eza --group-directories-first";
          ll = "eza -l --group-directories-first";
          la = "eza -lA --group-directories-first";
          tree = "eza --tree --group-directories-first";
          "..." = "../..";
        };

        interactiveShellInit = ''set fish_greeting'';
      };
    }
    // lib.genAttrs ["fd" "ripgrep" "jq" "yt-dlp"] (_: {enable = true;});
}
