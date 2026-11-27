# jellyfin behind nginx, TLS from a Cloudflare DNS-01 cert (same setup as vaultwarden).
# Cloudflare records are non-proxied; set SSL/TLS mode to "Full (strict)".
#
# Jellyfin has no public registration, so sign-up is a small separate service
# (./signup.py) that creates accounts through the admin API. It only exists while
# the toggle is on:
#
#   custom.jellyfin.signup.enable = true;   # hosts/<host>/configuration.nix, then push
#
# which serves a form at https://jellyfin.<domain>/signup.
# Secrets (see secrets/agenix-rules.nix):
#   cloudflare-dns-token.age   shared with vaultwarden: bare API token (Zone:DNS:Edit)
#   jellyfin-signup-env.age    only needed while signup is on:
#                                JELLYFIN_API_KEY=<Dashboard -> API Keys>
#                                INVITE_CODE=<shared passphrase>
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.jellyfin;

  domain = "engliz.dev";
  jellyfinHost = "jellyfin.${domain}";
  jellyfinPort = 8096; # jellyfin's default http port, bound locally only
  signupPort = 8097;

  secretsDir = ../../secrets;
  has = name: builtins.pathExists (secretsDir + "/${name}.age");
in {
  imports = [../nginx/host.nix];
  options.custom.jellyfin.signup.enable = lib.mkEnableOption "the temporary public sign-up page at /signup";

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = has "cloudflare-dns-token";
          message = "secrets/cloudflare-dns-token.age is missing: run `agenix -e cloudflare-dns-token.age` in secrets/ and git add it";
        }
      ];

      # same definition as modules/vaultwarden/host.nix; identical values merge fine,
      # and this keeps the module working without vaultwarden
      age.secrets.cloudflare-dns-token = lib.mkIf (has "cloudflare-dns-token") {
        file = secretsDir + "/cloudflare-dns-token.age";
      };

      services.jellyfin = {
        enable = true;
        # reached through nginx only
        openFirewall = false;
      };

      # drop media in /srv/jellyfin (login user is in the jellyfin group), then add it
      # as a library in the Jellyfin dashboard
      users.users.${config.cfg.user.name}.extraGroups = [config.services.jellyfin.group];
      systemd.tmpfiles.rules = ["d /srv/jellyfin 2775 ${config.services.jellyfin.user} ${config.services.jellyfin.group} -"];

      security.acme = {
        acceptTerms = true;
        defaults.email = config.cfg.user.email;
        certs.${jellyfinHost} = {
          dnsResolver = "1.1.1.1:53";
          dnsProvider = "cloudflare";
          credentialFiles = lib.optionalAttrs (has "cloudflare-dns-token") {
            CLOUDFLARE_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-dns-token.path;
          };
          group = config.services.nginx.group;
        };
      };

      services.nginx.virtualHosts.${jellyfinHost} = {
        useACMEHost = jellyfinHost;
        forceSSL = true;
        # posters/subtitles/etc. uploads from the dashboard
        extraConfig = ''
          client_max_body_size 20M;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString jellyfinPort}";
          proxyWebsockets = true;
          extraConfig = ''
            # stream media instead of spooling it to disk
            proxy_buffering off;
          '';
        };
      };
    }

    (lib.mkIf cfg.signup.enable {
      assertions = [
        {
          assertion = has "jellyfin-signup-env";
          message = "secrets/jellyfin-signup-env.age is missing: run `agenix -e jellyfin-signup-env.age` in secrets/ (JELLYFIN_API_KEY=..., INVITE_CODE=...) and git add it, or set custom.jellyfin.signup.enable = false";
        }
      ];

      age.secrets.jellyfin-signup-env = lib.mkIf (has "jellyfin-signup-env") {
        file = secretsDir + "/jellyfin-signup-env.age";
      };

      systemd.services.jellyfin-signup = {
        description = "Temporary Jellyfin sign-up page";
        wantedBy = ["multi-user.target"];
        after = ["jellyfin.service"];
        wants = ["jellyfin.service"];
        environment = {
          JELLYFIN_URL = "http://127.0.0.1:${toString jellyfinPort}";
          LISTEN_PORT = toString signupPort;
          PYTHONUNBUFFERED = "1";
        };
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.python3} ${./signup.py}";
          # read by systemd as root before dropping to the dynamic user
          EnvironmentFile = lib.mkIf (has "jellyfin-signup-env") config.age.secrets.jellyfin-signup-env.path;
          Restart = "on-failure";
          RestartSec = "5s";

          DynamicUser = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          CapabilityBoundingSet = "";
          SystemCallArchitectures = "native";
        };
      };

      services.nginx.virtualHosts.${jellyfinHost}.locations."= /signup" = {
        proxyPass = "http://127.0.0.1:${toString signupPort}";
        extraConfig = ''
          # a form post is tiny; keep the public endpoint cheap to abuse-proof
          client_max_body_size 8k;
        '';
      };
    })
  ];
}
