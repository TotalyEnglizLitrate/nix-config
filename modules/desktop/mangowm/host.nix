{
  outputs,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/host.nix
    inputs.mangowc.nixosModules.mango
  ];
  nixpkgs.overlays = with outputs.overlays; [mango noctalia];

  xdg.portal.config.mango = lib.mkForce {
    default = ["gtk" "wlr"];
    "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
    "org.freedesktop.impl.portal.ScreenShot" = ["wlr"];
    "org.freedesktop.impl.portal.Access" = ["gtk"];
    "org.freedesktop.impl.portal.Notification" = ["gtk"];
    "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
  };

  xdg.portal.wlr.settings = {
    screencast = {
      chooser_type = "dmenu";
      chooser_cmd = "${pkgs.noctalia}/bin/noctalia dmenu -p 'Select window/output:'";
    };
  };

  programs.mango = {
    enable = true;
    package = pkgs.mango;
  };
}
