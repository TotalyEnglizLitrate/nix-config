# media library on Cloudflare R2, mounted at /srv/jellyfin for jellyfin.
#
# /srv/jellyfin is an rclone `union` of two layers, mounted with a large local read cache:
#   - the R2 bucket, read-only: jellyfin can never modify or delete your jellyfin
#   - /var/lib/jellyfin-sidecars, local and writable: anything written lands here
# A timer then pushes only subtitle files from the local layer up to the bucket, so
# subtitles end up beside the videos in R2 and nothing else is ever written there.
#
# Secret, secrets/r2-jellyfin-rclone.age: just the credentials, as an rclone config
# section, with an R2 API token scoped to the bucket with R/W
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.jellyfin.r2;

  mountPoint = "/srv/jellyfin";
  sidecarDir = "/var/lib/jellyfin-sidecars";
  cacheDir = "/var/cache/rclone-jellyfin";
  runtimeConf = "/run/rclone-jellyfin.conf";
  subtitleGlob = "*.{srt,ass,ssa,sub,vtt}";

  rclone = lib.getExe pkgs.rclone;

  secretsDir = ../../secrets;
  hasSecret = builtins.pathExists (secretsDir + "/r2-jellyfin-rclone.age");

  # non-secret half of the config. first upstream is read-only; `ff` creates new files
  # on the first writable upstream (the local one) even when the directory only exists
  # in R2; deletes and edits can only reach writable upstreams, so R2 objects are
  # untouchable
  unionConf = pkgs.writeText "rclone-jellyfin-union.conf" ''

    [jellyfin]
    type = union
    upstreams = r2:${cfg.bucket}:ro ${sidecarDir}
    create_policy = ff
    action_policy = epall
  '';
in {
  options.custom.jellyfin.r2 = {
    enable = lib.mkEnableOption "the R2-backed jellyfin library at ${mountPoint}";
    bucket = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin";
      description = "R2 bucket holding the media";
    };
    cacheMaxSize = lib.mkOption {
      type = lib.types.str;
      default = "100G";
      description = ''
        Soft cap for the local read cache (rclone size syntax). The Always Free 200 GB
        is shared with the boot volume, so leave room for the OS, the nix store and
        jellyfin's database. The cap is soft because open files cannot be evicted.
      '';
    };
    cacheMinFreeSpace = lib.mkOption {
      type = lib.types.str;
      default = "30G";
      description = "Evict from the cache when free disk space drops below this, so it can never starve the system";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = hasSecret;
        message = "secrets/r2-jellyfin-rclone.age is missing: run `agenix -e r2-jellyfin-rclone.age` in secrets/ (an rclone `[r2]` section, see modules/jellyfin/r2.nix) and git add it";
      }
    ];

    age.secrets.r2-jellyfin-rclone = lib.mkIf hasSecret {
      file = secretsDir + "/r2-jellyfin-rclone.age";
    };

    # `mount -t rclone` looks for the mount.rclone helper that ships in this package
    environment.systemPackages = [pkgs.rclone];

    # credentials (secret) + union remote (store) -> one config file for the mount
    systemd.services.rclone-jellyfin-config = {
      description = "Assemble rclone config for the R2 jellyfin mount";
      before = ["srv-jellyfin.mount"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        UMask = "0077";
        ExecStart = "${pkgs.runtimeShell} -c '${pkgs.coreutils}/bin/cat ${config.age.secrets.r2-jellyfin-rclone.path} ${unionConf} > ${runtimeConf}'";
      };
    };

    fileSystems.${mountPoint} = {
      device = "jellyfin:";
      fsType = "rclone";
      options = [
        "nodev"
        "nofail"
        "_netdev"
        "x-systemd.automount"
        "x-systemd.requires=rclone-jellyfin-config.service"
        "allow_other"
        # everything after args2env is passed to rclone as flags (--foo-bar = foo_bar)
        "args2env"
        "config=${runtimeConf}"
        "cache_dir=${cacheDir}"
        "vfs_cache_mode=full"
        "vfs_cache_max_size=${cfg.cacheMaxSize}"
        "vfs_cache_min_free_space=${cfg.cacheMinFreeSpace}"
        # evict by size only (least recently used), never by age
        "vfs_cache_max_age=168h"
        # prefetch ahead of the playback position to hide per-request latency
        "vfs_read_ahead=512M"
        "vfs_read_chunk_size=32M"
        "vfs_read_chunk_size_limit=512M"
        "buffer_size=64M"
        # listings and attributes stay cached until the mount gets SIGHUP (see top)
        "dir_cache_time=168h"
        "attr_timeout=168h"
        "vfs_fast_fingerprint=true"
        "no_modtime=true"
      ];
    };

    systemd.tmpfiles.rules = ["d ${sidecarDir} 0755 root root -"];

    # jellyfin needs the mount: it triggers the automount when it starts, it is
    # stopped with the mount, and it refuses to start without it.
    systemd.services.jellyfin.unitConfig.RequiresMountsFor = [mountPoint];

    # push subtitles (and only subtitles) from the local layer to the bucket
    systemd.services.rclone-jellyfin-subtitles = {
      description = "Push downloaded subtitles to R2";
      after = ["network-online.target" "rclone-jellyfin-config.service"];
      wants = ["network-online.target"];
      requires = ["rclone-jellyfin-config.service"];
      serviceConfig = {
        Type = "oneshot";
        # --min-age: skip files jellyfin is still writing
        ExecStart = "${rclone} copy ${sidecarDir} r2:${cfg.bucket} --config ${runtimeConf} --include '${subtitleGlob}' --min-age 1m";
      };
    };
    systemd.timers.rclone-jellyfin-subtitles = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*:0/15";
        Persistent = true;
      };
    };
  };
}
