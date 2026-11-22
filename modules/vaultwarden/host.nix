# vaultwarden behind nginx, TLS from a Cloudflare DNS-01 cert.
# Cloudflare records are orange-cloud (proxied); set SSL/TLS mode to "Full (strict)".
#
# Needs two agenix secrets (see secrets/secrets.nix):
#   cloudflare-dns-token.age   just the bare API token (Zone:DNS:Edit on the zone)
#   vaultwarden-env.age        (optional) ADMIN_TOKEN='<argon2 hash from `vaultwarden hash`>'
{
  config,
  lib,
  ...
}: let
  domain = "engliz.dev";
  vaultHost = "vault.${domain}";
  port = 8222;

  secretsDir = ../../secrets;
  has = name: builtins.pathExists (secretsDir + "/${name}.age");
in {
  assertions = [
    {
      assertion = has "cloudflare-dns-token";
      message = "secrets/cloudflare-dns-token.age is missing: run `agenix -e cloudflare-dns-token.age` in secrets/ and git add it";
    }
  ];

  age.secrets = lib.mkMerge [
    (lib.mkIf (has "cloudflare-dns-token") {
      cloudflare-dns-token.file = secretsDir + "/cloudflare-dns-token.age";
    })
    (lib.mkIf (has "vaultwarden-env") {
      vaultwarden-env.file = secretsDir + "/vaultwarden-env.age";
    })
  ];

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/var/backup/vaultwarden";
    environmentFile = lib.mkIf (has "vaultwarden-env") config.age.secrets.vaultwarden-env.path;
    config = {
      DOMAIN = "https://${vaultHost}";
      # flip to true for the first deploy to create your account, then back to false
      # (or leave false and invite yourself from the admin page via ADMIN_TOKEN)
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = port;
      # real client IP as set by Cloudflare's proxy
      IP_HEADER = "CF-Connecting-IP";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = config.cfg.user.email;
    # a cert for this one hostname only, so the key here can't impersonate
    # the other subdomains deployed elsewhere
    certs.${vaultHost} = {
      dnsProvider = "cloudflare";
      credentialFiles = lib.optionalAttrs (has "cloudflare-dns-token") {
        CLOUDFLARE_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-dns-token.path;
      };
      group = config.services.nginx.group;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      ${vaultHost} = {
        useACMEHost = vaultHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };

      # anything that isn't a known hostname is dropped
      "_" = {
        default = true;
        rejectSSL = true;
        locations."/".return = "444";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
