{
  hostname,
  inputs,
  outputs,
  lib,
  config,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ./gdm.nix
    ./niri.nix
    ./cloudflare-warp.nix
    ./tuned.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.niri.overlays.niri
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) (lib.filterAttrs (_: lib.isType "flake") inputs);

  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry
    // {"environment".text = "LIBSEAT_BACKEND=logind";};

  nix.settings = {
    experimental-features = "nix-command flakes ca-derivations";
    auto-optimise-store = true;
    substituters = ["https://niri.cachix.org"];
    trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = ["quiet" "splash"];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    loader.timeout = lib.mkForce 1;
    plymouth = {
      enable = true;
      theme = "deus_ex";
      themePackages = with pkgs; [(adi1090x-plymouth-themes.override {selected_themes = ["deus_ex"];})];
    };

    kernelModules = [
      "v4l2loopback"
      "uinput"
      "hid-uclogic"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
  };

  networking.networkmanager.enable = lib.mkForce true;
  networking.hostName = hostname;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.libinput.enable = true;

  environment.localBinInPath = true;

  services.printing.enable = true;

  services.devmon.enable = true;

  services.seatd.enable = true;

  services.fwupd.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.${userConfig.name} = {
    description = userConfig.fullName;
    extraGroups = ["networkmanager" "wheel"];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  # use ca-derivations for manpages to speedup build time
  documentation.man.man-db.package = pkgs.man-db.overrideAttrs (final: prev: {__contentAddressed = true;});

  security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
    gcc
    glib
    gnumake
    killall
    mesa
  ];

  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    _0xproto
    dejavu_fonts
    liberation_ttf
    twitter-color-emoji
    font-awesome
    roboto
    source-sans-pro
    source-sans
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["0xProto Nerd Font" "0xProto" "DejaVu Sans" "Liberation"];
      sansSerif = ["0xProto Nerd Font" "Noto Sans" "DejaVu Sans" "Liberation Sans"];
      serif = ["Noto Serif" "DejaVu Serif" "Liberation Serif"];
    };
  };
  fonts.fontDir.enable = true;

  services.locate.enable = true;

  services.openssh.enable = true;

  programs.nix-ld.enable = true;
  systemd.tmpfiles.rules = [
    ''L+ /lib64/libstdc++.so.6 - - - - ${pkgs.stdenv.cc.cc.lib}/lib64/libstdc++.so.6''
    ''L+ /lib64/libz.so.1 - - - - ${pkgs.zlib}/lib/libz.so.1''
  ];
  environment.variables = {
    NIX_LD_LIBRARY_PATH = lib.mkForce "/lib64";
  };

  programs.kdeconnect.enable = true;

  programs.dconf.enable = true;
}
