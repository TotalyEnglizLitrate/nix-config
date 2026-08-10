{
  lib,
  outputs,
  inputs,
  pkgs,
  ...
}: {
  imports = [../common/host.nix inputs.niri-nix.nixosModules.default];
  nixpkgs.overlays = [outputs.overlays.niri];

  xdg.portal.xdgOpenUsePortal = lib.mkForce false;

  # niri ships this as niri-portals.conf, but only under the package's share dir,
  # which loses to /etc/xdg. Declare it so screencast lands on gnome instead of
  # falling back to wlr, which mango's module pulls in system-wide.
  xdg.portal.config.niri = lib.mkForce {
    default = ["gnome" "gtk"];
    "org.freedesktop.impl.portal.Access" = ["gtk"];
    "org.freedesktop.impl.portal.Notification" = ["gtk"];
    "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
  };

  nix.settings = {
    substituters = lib.mkAfter ["https://niri-nix.cachix.org"];
    trusted-public-keys = ["niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="];
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  environment.systemPackages = [pkgs.xwayland-satellite-unstable];
}
