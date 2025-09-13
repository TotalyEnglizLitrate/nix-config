{...}: {
  # Starship configuration
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

      directory = {
        disabled = false;
        truncation_length = 3;
        truncation_symbol = ".../";
        substitutions = {
          "nix-config" = " ";
          "repositories" = " ";
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "~" = " ";
        };
        read_only = "󰉐 ";
        read_only_style = "red";
        format = "[ $path [$read_only](fg:red bg:#2587be)](bg:#2587be)[ ](fg:#2587be)";
      };

      format = ''
        $directory
        $cmd_duration $character
      '';

      right_format = ''$git_branch$git_status'';
    };
  };
}
