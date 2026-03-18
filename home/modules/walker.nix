{...}:
let providers = [
  # uncomment once walker catches up to newer elephant release
  # "bitwarden"
  # "niriactions"
  "bluetooth"
  "calc"
  "clipboard"
  "desktopapplications"
  "files"
  "providerlist"
  "runner"
  "symbols"
  "todo"
  "unicode"
  "websearch"
  "windows"
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
    };
  };
}
