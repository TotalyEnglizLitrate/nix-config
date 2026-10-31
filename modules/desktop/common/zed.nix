{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = true;
    mutableUserKeymaps = true;
    mutableUserTasks = true;
    extensions = [
      "nix"
      "toml"
      "lua"
      "basher"
      "typst"
      "basedpyright"
      "typos"
      "markdown-oxide"
    ];
    extraPackages = with pkgs; [
      lazygit
      lua-language-server
      stylua
      nixd
      alejandra
      rust-analyzer
      basedpyright
      black
      clang-tools
      gopls
      typescript-language-server
      tinymist
      typos-lsp
      markdown-oxide
    ];

    userTasks = [
      {
        label = "lazygit";
        command = "lazygit";
        use_new_terminal = true;
        allow_concurrent_runs = false;
        reveal = "always";
        hide = "on_success";
      }
    ];

    userSettings = {
      vim_mode = true;
      vim = {
        use_system_clipboard = "always";
        use_smartcase_find = true;
        highlight_on_yank_duration = 200;
      };
      vertical_scroll_margin = 10;
      show_whitespaces = "all";
      soft_wrap = "none";
      git = {
        inline_blame = {
          enabled = true;
        };
      };
      which_key = {
        enabled = true;
      };
      file_finder = {
        modal_max_width = "medium";
      };
      tab_bar = {
        show = true;
      };
      tabs = {
        show_diagnostics = "errors";
      };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      inlay_hints = {
        enabled = true;
      };
      auto_install_extensions = true;
      project_panel = {
        dock = "left";
      };
      outline_panel = {
        dock = "left";
      };
      collaboration_panel = {
        dock = "left";
      };

      agent = {
        enabled = false;

        default_model = {
          provider = "zed.dev";
          model = "claude-4-5-sonnet-latest";
        };
      };

      node = {
        path = lib.getExe pkgs.nodejs_22;
        npm_path = lib.getExe' pkgs.nodejs_22 "npm";
      };

      auto_update = false;
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          EDITOR = "zed --wait";
          TERM = "ghostty";
        };
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        working_directory = "current_project_directory";
      };
      # File syntax highlighting
      file_types = {
        JSON = [
          "json"
          "jsonc"
          "*.code-snippets"
        ];
      };
      languages = {
        Lua = {
          formatter = {
            external = {
              command = "stylua";
              arguments = ["--stdin-filepath" "{buffer_path}" "-"];
            };
          };
        };
        Python = {
          language_servers = ["basedpyright" "!pyright" "..."];
          formatter = {
            external = {
              command = "black";
              arguments = ["--quiet" "-"];
            };
          };
        };
        Nix = {
          formatter = {
            external = {
              command = "alejandra";
              arguments = ["-"];
            };
          };
        };
        Markdown = {
          language_servers = ["markdown-oxide" "typos" "..."];
          formatter = "prettier";
        };
        JSON = {
          formatter = "prettier";
        };
        TOML = {
          formatter = "prettier";
        };
      };

      lsp = {
        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
        "lua-language-server" = {
          settings = {
            Lua = {
              signatureHelp = {enabled = true;};
              diagnostics = {
                globals = ["vim" "nixCats"];
                disable = ["missing-fields"];
              };
            };
          };
        };

        "rust-analyzer" = {
          settings = {
            diagnostics = {
              enable = true;
              styleLints = {
                enable = true;
              }; # Corrected styleLints access
            };
            checkOnSave = true;
            check = {
              command = "clippy";
              features = "all";
            };
            cargo = {
              buildScripts = {
                enable = true;
              }; # Corrected buildScripts access
              features = "all";
            };
            inlayHints = {
              bindingModeHints = {
                enable = true;
              }; # Corrected access
              closureStyle = "rust_analyzer";
              closureReturnTypeHints = {
                enable = "always";
              }; # Corrected access
              discriminantHints = {
                enable = "always";
              }; # Corrected access
              expressionAdjustmentHints = {
                enable = "always";
              }; # Corrected access
              implicitDrops = {
                enable = true;
              };
              lifetimeElisionHints = {
                enable = "always";
              }; # Corrected access
              rangeExclusiveHints = {
                enable = true;
              };
            };
            procMacro = {
              enable = true;
            };
            rustc = {
              source = "discover";
            };
            files = {
              excludeDirs = [
                ".cargo"
                ".direnv"
                ".git"
                "node_modules"
                "target"
              ];
            };
          };
        };
      };
    };

    userKeymaps = [
      {
        context = "Editor && (vim_mode == normal || vim_mode == visual)";
        bindings = {
          "space g d" = "editor::ToggleSelectedDiffHunks";
          "space g r" = "git::Restore";
          "space g s" = "git::StageAndNext";
          "space g b" = "editor::ToggleGitBlameInline";
          "space g t b" = "editor::ToggleGitBlameInline";
          "space g g" = ["task::Spawn" {task_name = "lazygit";}];
          "space t i" = "editor::ToggleInlayHints";
          "space u w" = "editor::ToggleSoftWrap";
          "space c z" = "workspace::ToggleCenteredLayout";
          "space m p" = "markdown::OpenPreview";
          "space m P" = "markdown::OpenPreviewToTheSide";
          "space f p" = "projects::OpenRecent";
          "space c f" = "editor::Format";
          "space a c" = "assistant::ToggleFocus";
          "ctrl-/" = "editor::ToggleComments";
        };
      }
      {
        context = "Editor && vim_mode == normal && !VimWaiting && !menu";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "editor::ShowSignatureHelp";
          "ctrl-j" = "workspace::ActivatePaneDown";
          "space c a" = "editor::ToggleCodeActions";
          "space r n" = "editor::Rename";
          "space D" = "editor::GoToTypeDefinition";
          "g d" = "editor::GoToDefinition";
          "g D" = "editor::GoToDefinitionSplit";
          "g I" = "editor::GoToImplementation";
          "g r" = "editor::FindAllReferences";
          "space c s" = "outline::Toggle";
          "space c w s" = "project_symbols::Toggle";
          "space c d f" = "editor::Hover";
          "space c d l" = "diagnostics::Deploy";

          # +Search
          "space s f" = "file_finder::Toggle";
          "space s F" = "file_finder::Toggle";
          "space s G" = "file_finder::Toggle";
          "space s g" = "pane::DeploySearch";
          "space s w" = "pane::DeploySearch";
          "space s b" = "buffer_search::Deploy";
          "space s d" = "diagnostics::Deploy";
          "space s D" = "diagnostics::Deploy";
          "space s k" = "zed::OpenKeymap";

          # +Git
          # Git prev/next hunk
          "] c" = "editor::GoToHunk";
          "[ c" = "editor::GoToPrevHunk";

          # Buffers
          "shift-h" = "pane::ActivatePrevItem";
          "shift-l" = "pane::ActivateNextItem";
          "space b d" = "pane::CloseActiveItem";
          "space b c" = "pane::CloseInactiveItems";
          "space b H" = "pane::CloseItemsToTheLeft";
          "space b L" = "pane::CloseItemsToTheRight";
          "space q c" = "pane::CloseActiveItem";
          "space q q" = "zed::Quit";
          "space space" = "file_finder::Toggle";
          # Explorer
          "space e" = "project_panel::ToggleFocus";
        };
      }
      {
        context = "Editor && (vim_mode == normal || vim_mode == insert)";
        bindings = {
          "ctrl-s" = "workspace::Save";
        };
      }
      {
        context = "EmptyPane || SharedScreen";
        bindings = {
          "space space" = "file_finder::Toggle";
          "space f p" = "projects::OpenRecent";
        };
      }
      {
        context = "Editor && vim_mode == visual && !VimWaiting && !menu";
        bindings = {
          "shift-j" = "editor::MoveLineDown";
          "shift-k" = "editor::MoveLineUp";
        };
      }
      {
        context = "Editor && vim_mode == insert";
        bindings = {
          "ctrl-/" = "editor::ToggleComments";
        };
      }
      # Toggle Terminal
      {
        context = "Workspace";
        bindings = {
          "ctrl-\\" = "terminal_panel::ToggleFocus";
          "ctrl-b" = "workspace::ToggleLeftDock";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
      # File panel (netrw)
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          "a" = "project_panel::NewFile";
          "A" = "project_panel::NewDirectory";
          "r" = "project_panel::Rename";
          "d" = "project_panel::Delete";
          "x" = "project_panel::Cut";
          "c" = "project_panel::Copy";
          "p" = "project_panel::Paste";
          "q" = "workspace::ToggleLeftDock";
          "space e" = "workspace::ToggleLeftDock";
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
      {
        context = "Dock";
        bindings = {
          "ctrl-w h" = "workspace::ActivatePaneLeft";
          "ctrl-w l" = "workspace::ActivatePaneRight";
          "ctrl-w k" = "workspace::ActivatePaneUp";
          "ctrl-w j" = "workspace::ActivatePaneDown";
        };
      }
    ];
  };
}
