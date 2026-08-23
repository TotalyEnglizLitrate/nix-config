{
  config,
  lib,
  ...
}: {
  programs.umbriel.settings = let
    colors = config.lib.stylix.colors.withHashtag;
  in {
    colors = {
      background = "${colors.base00}F0";
      text_primary = "${colors.base05}FF";
      text_muted = "${colors.base03}FF";
      accent_primary = "${colors.base0D}FF";
      accent_secondary = "${colors.base0C}FF";
      warning = "${colors.base0A}FF";
      error = "${colors.base08}FF";
    };

    appearance = {
      border_focused = "${colors.base0D}FF";
      border_unfocused = "${colors.base03}FF";
      scratchpad_border_focused = "${colors.base0A}FF";
      scratchpad_border_unfocused = "${colors.base02}FF";
      outer_border_color = "${colors.base01}FF";
      backdrop_color = "${colors.base00}FF";
    };
  };
}
