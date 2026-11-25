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
    openssh.authorizedKeys.keys = config.cfg.user.loginKeys;
  };
  programs.${config.cfg.user.shell}.enable = true;

  # passwordless sudo only while ssh'd in with an agent forwarded (`ssh -A`/ForwardAgent):
  # pam_ssh_agent_auth checks the forwarded agent for a key listed in loginKeys.
  # With no agent it falls through to the normal password prompt.
  security = {
    sudo.wheelNeedsPassword = true;
    pam = {
      sshAgentAuth = {
        enable = true;
        authorizedKeysFiles = ["/etc/ssh/authorized_keys.d/%u"];
      };
      services.sudo.sshAgentAuth = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowAgentForwarding = true;
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

  # terminfo for whatever terminal you ssh in from (xterm-ghostty, kitty, ...)
  environment.enableAllTerminfo = true;
  # nixos-cli is set to use nom for builds
  environment.systemPackages = [pkgs.nix-output-monitor];

  # keep the closure small
  documentation.enable = false;
  environment.defaultPackages = [];
}
