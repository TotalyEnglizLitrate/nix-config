{
  lib,
  inputs,
  pkgs,
  userConfig,
  ...
}: let
  # autologin on tty2. Otherwise autologin and getty alternate in grabbing tty1 on nixos-rebuild switch
  autologin_on_2 = pkgs.autologin.overrideAttrs (_: {
    postPatch = ''
      substituteInPlace "main.c" \
        --replace-fail "setup_vt(1);" "setup_vt(2);" \
        --replace-fail "XDG_VTNR=1" "XDG_VTNR=2"
    '';
  });
in {
  imports = [./noctalia/host.nix];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  nix.settings = {
    extra-substituters = lib.mkAfter ["https://niri.cachix.org"];
    trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
  };
  niri-flake.cache.enable = false;
  systemd.user.services.niri-flake-polkit.enable = false;

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
    gnome = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
    };
    xserver.updateDbusEnvironment = true;
  };
  security = {
    polkit.enable = true;
  };

  environment.systemPackages = [
    autologin_on_2
    pkgs.polkit_gnome
  ];

  systemd.services.autologin = {
    enable = true;
    restartIfChanged = lib.mkForce false;
    description = "Autologin";
    after = [
      "systemd-user-sessions.service"
    ];

    serviceConfig = {
      ExecStart = "${autologin_on_2}/bin/autologin ${userConfig.name} ${pkgs.niri-unstable}/bin/niri-session";
      Type = "simple";
      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
      TimeoutStopSec = "30s";
      KeyringMode = "shared";
      Restart = "always";
      RestartSec = "2";
    };
    startLimitBurst = 5;
    startLimitIntervalSec = 30;
    aliases = ["display-manager.service"];
    wantedBy = ["multi-user.target"];
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
