{pkgs, ...}: let
in {
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    enableFishIntegration = true;
    attachExistingSession = true;
    settings = {
      keybinds = {
        normal = [
          {
            bind = "Ctrl Shift h";
            action = ["MoveFocusOrTab" "Left"];
          }
          {
            bind = "Ctrl Shift j";
            action = ["MoveFocusOrTab" "Down"];
          }
          {
            bind = "Ctrl Shift k";
            action = ["MoveFocusOrTab" "Up"];
          }
          {
            bind = "Ctrl Shift l";
            action = ["MoveFocusOrTab" "Right"];
          }
        ];
      };
    };
  };
}
