{lib, osConfig, ...}: {
  stylix.targets.noctalia-shell.enable = false;

  home.file.".config/noctalia/palettes/stylix.json".text = lib.toJSON (with osConfig.lib.stylix.colors.withHashtag; {
    dark = {
      mPrimary = base0D;
      mOnPrimary = base00;
      mSecondary = base0C;
      mOnSecondary = base00;
      mTertiary = base0E;
      mOnTertiary = base00;
      mError = base08;
      mOnError = base00;
      mSurface = base00;
      mOnSurface = base05;
      mSurfaceVariant = base02;
      mOnSurfaceVariant = base04;
      mOutline = base03;
      mShadow = base00;
      mHover = base01;
      mOnHover = base05;
      terminal = {
        normal = {
          black = base00;
          red = base08;
          green = base0B;
          yellow = base0A;
          blue = base0D;
         magenta = base0E;
          cyan = base0C;
          white = base05;
        };
        bright = {
          black = base03;
          red = base08;
          green = base0B;
          yellow = base0A;
          blue = base0D;
          magenta = base0E;
          cyan = base0C;
          white = base07;
        };
      };
    };
  });
}
