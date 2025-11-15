{pkgs, ...}: {
  services.xserver.updateDbusEnvironment = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  environment.sessionVariables = {
    XDG_RUNTIME_DIR = "/run/user/$EUID";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

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
    hypridle
    hyprlock
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
    xwayland-satellite-unstable
    grim
    slurp

    gitkraken
  ];
}
