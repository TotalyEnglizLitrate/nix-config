{pkgs, ...}: {
  # Call dbus-update-activation-environment on login
  services.xserver.updateDbusEnvironment = true;

  # Enables support for Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.niri.enable = true;

  # Enable Bluetooth support
  services.blueman.enable = true;

  # Enable security services
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  environment.sessionVariables = {
    # Enable Ozone Wayland support in Chromium and Electron based applications
    XDG_RUNTIME_DIR = "/run/user/$EUID";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # Other general env vars
    XDG_SESSION_DESKTOP = "niri";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome
    brightnessctl
    swayidle
    hypridle
    hyprpicker
    swww
    swaynotificationcenter
    libnotify
    networkmanagerapplet
    pamixer
    wlr-randr
    tesseract
    wl-clipboard
    cliphist
    arrpc
    playerctl
    xwayland-satellite

    gitkraken
    vscode
  ];
}
