# Minimal headless-server baseline (the desktop one is modules/common/host.nix)
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [../agenix/host.nix];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      # lets `nixos-rebuild --target-host` copy closures as a non-root user
      trusted-users = ["@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  networking.hostName = config.cfg.host.hostname;
  time.timeZone = "UTC";

  # passwords come from the config (agenix), not imperative `passwd`
  users.mutableUsers = false;
  users.users.${config.cfg.user.name} = {
    description = config.cfg.user.fullName;
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.${config.cfg.user.shell};
    # the same keys that sign git commits are the ssh login keys
    openssh.authorizedKeys.keys = config.cfg.user.signingKeys;
  };
  programs.${config.cfg.user.shell}.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    # repeat offenders get progressively longer bans
    bantime-increment = {
      enable = true;
      maxtime = "168h";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22];
  };

  # keep the closure small
  documentation.enable = false;
  environment.defaultPackages = [];
}
