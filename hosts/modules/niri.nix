{
  lib,
  inputs,
  pkgs,
  userConfig,
  ...
}: 
let
  # autologin on tty2. Otherwise autologin and getty alternate in grabbing tty1 on nixos-rebuild switch
  autologin_on_2 = pkgs.autologin.overrideAttrs (_: {
    postPatch = ''
      substituteInPlace "main.c" \
        --replace-fail "setup_vt(1);" "setup_vt(2);" \
        --replace-fail "XDG_VTNR=1" "XDG_VTNR=2"
    '';
  });
in {
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  niri-flake.cache.enable = false;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    xserver.updateDbusEnvironment = true;
  };
  security = {
    polkit.enable = true;
  };

  environment.systemPackages = [ autologin_on_2 pkgs.polkit_gnome ];

  systemd.services.autologin = {
    enable = true;
    restartIfChanged = lib.mkForce false;
    description = "Autologin";
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
    ];

    serviceConfig = {
      ExecStart = "${autologin_on_2}/bin/autologin ${userConfig.name} ${pkgs.niri-unstable}/bin/niri-session";
      Type = "simple";
      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
      TimeoutStopSec = "30s";
      KeyringMode = "shared";
      Restart = "always";
      RestartSec = "10";
    };
    startLimitBurst = 5;
    startLimitIntervalSec = 30;
    aliases = [ "display-manager.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  security.pam.services.autologin = {
    enable = true;
    name = "autologin";
    startSession = true;
    setLoginUid = true;
    updateWtmp = true;
    enableGnomeKeyring = true;
  };
}
