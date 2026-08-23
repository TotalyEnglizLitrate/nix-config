{
  lib,
  outputs,
  inputs,
  pkgs,
  ...
}: {
  imports = [../common/host.nix inputs.umbriel.nixosModules.default];
  nixpkgs.overlays = [outputs.overlays.umbriel];

  xdg.portal.xdgOpenUsePortal = lib.mkForce false;

  xdg.portal.config.umbriel = lib.mkForce {
    default = ["umbriel" "gnome" "gtk"];
    "org.freedesktop.impl.portal.Access" = ["gtk"];
    "org.freedesktop.impl.portal.Notification" = ["gtk"];
    "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
  };

  programs.umbriel = {
    enable = true;
    package = pkgs.umbriel;
  };

  environment.systemPackages = [pkgs.umbriel-desktop-portal];
}
