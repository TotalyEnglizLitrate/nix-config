{pkgs, userConfig, ...}:
let providers = [
  "bitwarden"
  "bluetooth"
  "calc"
  "clipboard"
  "desktopapplications"
  "files"
  "niriactions"
  "providerlist"
  "runner"
  "symbols"
  "todo"
  "unicode"
  "websearch"
  "windows"
  "wireplumber"
  ];
in {
  programs.walker = {
    enable = true;
    runAsService = true;
    elephant.providers = providers;
    config = {
      force_keyboard_focus = true;
      page_jump_items = 5;
      keybinds.quick_activate = ["F1" "F2" "F3" "F4" "F5" "F6"];
      providers.actions.bitwarden = [
        {
          action = "copytotp";
          bind = "ctrl Return";
          label = "copy 2fa";
        }
      ];
    };
  };

  programs.rbw = {
    enable = true;
    settings = {
      email = userConfig.email;
      base_url = "https://bitwarden.garudalinux.org";
      lock_timeout = 3600;
      pinentry = pkgs.pinentry-gnome3;
    };
  };

  home.packages = [ pkgs.wtype ];
}
