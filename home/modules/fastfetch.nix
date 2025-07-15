{...}: {
  # Install and configure fastfetch via home-manager module
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        height = 18;
      };
      display = {
        separator = " : ";
      };
      modules = [
        {
          type = "title";
          format = "                      {##a834eb}{1}@{2}";
        }
        "break"
        {
          type = "custom";
          format = "┌────────────────────────────────────────────────────────────────┐";
        }
        "break"
        {
          key = "     OS           ";
          keyColor = "red";
          type = "os";
        }
        {
          key = "    󰌢 Machine      ";
          keyColor = "green";
          type = "host";
        }
        {
          key = "     Kernel       ";
          keyColor = "magenta";
          type = "kernel";
        }
        {
          key = "    󰏖 Packages     ";
          type = "packages";
        }
        {
          key = "    󰅐 Uptime       ";
          keyColor = "red";
          type = "uptime";
        }
        {
          key = "    󰍹 Resolution   ";
          keyColor = "yellow";
          type = "display";
          compactType = "original-with-refresh-rate";
        }
        {
          key = "     WM           ";
          keyColor = "blue";
          type = "wm";
        }
        {
          key = "     DE           ";
          keyColor = "green";
          type = "de";
        }
        {
          key = "     Shell        ";
          keyColor = "cyan";
          type = "shell";
        }
        {
          key = "     Terminal     ";
          keyColor = "red";
          type = "terminal";
        }
        {
          key = "    󰻠 CPU          ";
          keyColor = "yellow";
          type = "cpu";
        }
        {
          key = "    󰍛 GPU          ";
          keyColor = "blue";
          type = "gpu";
        }
        {
          key = "    󰑭 Memory       ";
          keyColor = "magenta";
          type = "memory";
        }
        {
          key = "    󰩟 Local IP     ";
          keyColor = "red";
          type = "localip";
        }
        {
          key = "    󰩠 Public IP    ";
          keyColor = "cyan";
          type = "publicip";
        }
        "break"
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────────────────┘";
        }
        "break"
      ];
    };
  };
}
