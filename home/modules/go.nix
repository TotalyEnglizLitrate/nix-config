{...}: {
  programs.go = {
    enable = true;
    goBin = "go/bin";
    goPath = "go";
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];
}
