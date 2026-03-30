{
  lib,
  pkgs,
  userConfig,
  ...
}: let
  makeBindings = bindings:
    lib.mapAttrs'
    (bind: action: lib.nameValuePair "bind \"${bind}\"" action)
    bindings;
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
      theme = "default";
      theme_dir = "/home/${userConfig.name}/.config/zellij/themes";
      keybinds = {
        normal = makeBindings {
          "Ctrl Shift h" = {MoveFocusOrTab = "Left";};
          "Ctrl Shift j" = {MoveFocusOrTab = "Down";};
          "Ctrl Shift k" = {MoveFocusOrTab = "Up";};
          "Ctrl Shift l" = {MoveFocusOrTab = "Right";};
          "Alt t" = {NewTab = {};};
          "Alt w" = {CloseTab = {};};
          "Alt e" = {
            "LaunchPlugin \"filepicker\"" = {floating = true;};
          };
        };
      };
    };
  };
}
