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
    inputs.niri.nixosModules.niri
    ./gdm.nix
    ./niri.nix
    ./nh.nix
    ./cloudflare-warp.nix
    ./tuned.nix
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.niri.overlays.niri
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Register flake inputs for nix commands
  nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) (lib.filterAttrs (_: lib.isType "flake") inputs);

  # Add inputs to legacy channels
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry
    // {"environment".text = "LIBSEAT_BACKEND=logind";};
  # Nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    substituters = ["https://niri.cachix.org"];
    trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
  };

  # Boot settings
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_16;
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

    # v4l (virtual camera) module settings
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

  # Networking
  networking.networkmanager.enable = lib.mkForce true;
  networking.hostName = hostname;

  # Timezone
  time.timeZone = "Asia/Kolkata";

  # Internationalization
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

  # Input settings
  services.libinput.enable = true;

  # PATH configuration
  environment.localBinInPath = true;

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable devmon for device management
  services.devmon.enable = true;

  #Enable seatd for wlroots
  services.seatd.enable = true;

  # Enable PipeWire for sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User configuration
  users.users.${userConfig.name} = {
    description = userConfig.fullName;
    extraGroups = ["networkmanager" "wheel"];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  # Shell
  programs.fish.enable = true;

  # Require password for sudo
  security.sudo.wheelNeedsPassword = true;

  # System packages
  environment.systemPackages = with pkgs; [
    gcc
    glib
    gnumake
    killall
    mesa
  ];

  # Fonts configuration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    roboto
  ];

  # Additional services
  services.locate.enable = true;

  # OpenSSH daemon
  services.openssh.enable = true;

  # Running dynamically linked executables
  programs.nix-ld.enable = true;

  programs.kdeconnect.enable = true;

  # Required for the easyeffects daemon to work properly
  programs.dconf.enable = true;
}
