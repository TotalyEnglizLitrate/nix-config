{
  lib,
  pkgs,
  config,
  ...
}: let
  makeBindings = bindings: lib.mapAttrs' (bind: action: lib.nameValuePair "bind \"${bind}\"" action) bindings;
in {
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    enableFishIntegration = true;
    attachExistingSession = true;
    settings = {
      show_startup_tips = false;
      show_release_notes = false;
      ui.pane_frames.rounded_corners = false;
      keybinds = {
        normal = makeBindings {
          "Ctrl Shift h" = {
            MoveFocusOrTab = "Left";
          };
          "Ctrl Shift j" = {
            MoveFocusOrTab = "Down";
          };
          "Ctrl Shift k" = {
            MoveFocusOrTab = "Up";
          };
          "Ctrl Shift l" = {
            MoveFocusOrTab = "Right";
          };
          "Alt t" = {
            NewTab = {};
          };
          "Alt w" = {
            CloseTab = {};
          };
          "Alt e" = {
            "LaunchPlugin \"filepicker\"" = {
              floating = true;
            };
          };
        };
      };
    }
    # the themes dir only exists where stylix generates it (not on the server)
    // lib.optionalAttrs (config.stylix.enable or false) {
      theme = "default";
      theme_dir = "${config.home.homeDirectory}/.config/zellij/themes";
    };
  };
}
