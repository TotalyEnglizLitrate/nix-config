{pkgs, ...}: {
  # Install and configure fastfetch via home-manager module
  home.packages = with pkgs; [hyfetch];
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
          keyColor = "green";
          type = "os";
        }
        {
          key = "    󰌢 Machine      ";
          keyColor = "green";
          type = "host";
        }
        {
          key = "    󰻠 CPU          ";
          keyColor = "blue";
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
          key = "     Disk         ";
          keyColor = "magenta";
          type = "disk";
        }
        {
          key = "    󰍹 Resolution   ";
          keyColor = "red";
          type = "display";
          compactType = "original-with-refresh-rate";
        }
        {
          key = "     WM           ";
          keyColor = "red";
          type = "wm";
        }
        {
          key = "     Kernel       ";
          keyColor = "cyan";
          type = "kernel";
        }
        {
          key = "    󰏖 Packages     ";
          keyColor = "cyan";
          type = "packages";
        }
        {
          key = "    󰅐 Uptime       ";
          keyColor = "cyan";
          type = "uptime";
        }
        {
          key = "     Shell        ";
          keyColor = "blue";
          type = "shell";
        }
        {
          key = "     Terminal     ";
          keyColor = "blue";
          type = "terminal";
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
