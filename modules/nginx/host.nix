{...}: let
  log = "/var/log/nginx/access.log";
  jail = filter: extra: {
    settings =
      {
        enabled = true;
        inherit filter;
        logpath = log;
        backend = "auto"; # file-based, not journald
        port = "http,https";
      }
      // extra;
  };
in {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    # in addition to the journald log, not instead of it
    commonHttpConfig = ''
      access_log ${log};
    '';

    # anything that isn't a known hostname is dropped
    virtualHosts."_" = {
      default = true;
      rejectSSL = true;
      locations."/".return = "444";
    };
  };

  services.fail2ban.jails = {
    # shipped filters
    nginx-botsearch = jail "nginx-botsearch" {}; # probing for /wp-login.php, /.env, ...
    nginx-bad-request = jail "nginx-bad-request" {}; # malformed requests

    # custom filters
    nginx-unknown-host = jail "nginx-unknown-host" {maxretry = 2;};
    nginx-jellyfin-auth = jail "nginx-jellyfin-auth" {maxretry = 3;};
    nginx-signup = jail "nginx-signup" {maxretry = 3;};
  };

  environment.etc = {
    # the catch-all vhost answers 444 to any request for a hostname we don't serve, so only scanners hit it
    "fail2ban/filter.d/nginx-unknown-host.conf".text = ''
      [Definition]
      failregex = ^<HOST> - \S+ \[[^\]]+\] "[^"]*" 444 
    '';
    # wrong Jellyfin password
    "fail2ban/filter.d/nginx-jellyfin-auth.conf".text = ''
      [Definition]
      failregex = ^<HOST> - \S+ \[[^\]]+\] "POST /Users/[Aa]uthenticate[Bb]y[Nn]ame[^"]*" 401 
    '';
    # bad invite code, bad input or rate limit on the temporary /signup form
    "fail2ban/filter.d/nginx-signup.conf".text = ''
      [Definition]
      failregex = ^<HOST> - \S+ \[[^\]]+\] "POST /signup[^"]*" 4(00|03|29) 
    '';
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
