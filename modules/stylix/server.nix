# stylix for headless hosts: just the palette, applied to the tty and the
# terminal tools in modules/shell. No fonts, icons, cursor, gtk or qt.
_: {
  stylix = {
    enable = true;
    # only the targets listed below, nothing pulled in implicitly
    autoEnable = false;
    base16Scheme = ../../files/themes/tokyo-night-terminal-dark.yaml;
    polarity = "dark";

    targets.console.enable = true;
  };

  home-manager.sharedModules = [
    {
      stylix.targets = {
        bat.enable = true;
        btop.enable = true;
        fish.enable = true;
        fzf.enable = true;
        starship.enable = true;
        zellij.enable = true;
      };
    }
  ];
}
