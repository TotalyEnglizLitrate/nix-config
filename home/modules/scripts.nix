{...}: let
  scripts = ./../../files/scripts;
in {
  home.file = {
    ".local/bin" = {
      recursive = true;
      source = "${scripts}";
    };
  };
}
