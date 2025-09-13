{
  lib,
  pkgs,
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
      keybinds = {
        normal = makeBindings {
          "Ctrl Shift h" = {MoveFocusOrTab = "Left";};
          "Ctrl Shift j" = {MoveFocusOrTab = "Down";};
          "Ctrl Shift k" = {MoveFocusOrTab = "Up";};
          "Ctrl Shift l" = {MoveFocusOrTab = "Right";};
          "Alt t" = {NewTab = {};};
          "Alt w" = {CloseTab = {};};
        };
      };
    };
  };
}
