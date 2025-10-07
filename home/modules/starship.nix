{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = {
      package.disabled = true;

      cmd_duration = {
        disabled = false;
        min_time = 0;
        format = "[$duration]($style) ";
      };

      git_status = {
        format = "$all_status$ahead_behind ";
        ahead = "[⬆](bold purple) ";
        behind = "[⬇](bold purple) ";
        staged = "[✚](green) ";
        deleted = "[✖](red) ";
        renamed = "[➜](purple) ";
        stashed = "[✭](cyan) ";
        untracked = "[◼](white) ";
        modified = "[✱](blue) ";
        conflicted = "[═](yellow) ";
        diverged = "⇕ ";
        up_to_date = "";
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "bold green";
      };

      container = {
        disabled = false;
        style = "fg:red bg:#2587be";
        format = "[ $symbol]($style)";
      };

      directory = {
        disabled = false;
        truncation_length = 3;
        truncation_symbol = ".../";
        substitutions = {
          "nix-config" = "  ";
          "repositories" = "  ";
          "Documents" = " 󰈙 ";
          "Downloads" = "  ";
          "~" = " ";
        };
        read_only = " 󰉐 ";
        read_only_style = "red";
        format = "[ [$path](fg:#ffffff bg:#2587be) [$read_only](fg:red bg:#2587be)](bg:#2587be)[ ](fg:#2587be)";
      };

      format = ''
        $container$directory
        $cmd_duration $character
      '';

      right_format = ''$git_branch$git_status'';
    };
  };
}
