{pkgs, ...}: {
  systemd.services.warp-svc = {
    enable = true;
    description = "Cloudflare Zero Trust Client Daemon";
    after = ["pre-network.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
      DynamicUser = "no";
      CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_NET_RAW CAP_SETUID CAP_SETGID";
      AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_NET_RAW CAP_SETUID CAP_SETGID";
      StateDirectory = "cloudflare-warp";
      RuntimeDirectory = "cloudflare-warp";
      LogsDirectory = "cloudflare-warp";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };
  environment.systemPackages = with pkgs; [cloudflare-warp];
}
