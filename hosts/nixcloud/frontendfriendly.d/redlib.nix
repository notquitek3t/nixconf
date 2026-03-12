{ config, pkgs, lib, ... }:

let
  domain       = "frontendfriendly.xyz";
  host         = "redlib.${domain}";
  upstreamPort = 7105;
in
{
  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    port    = upstreamPort;
    # extraSettings = { ... }; # if you want instance-specific options
  };

  services.anubis.instances.redlib = {
    enable = true;
    settings = {
      BIND         = "/run/anubis/anubis-redlib/anubis.sock";
      METRICS_BIND = "/run/anubis/anubis-redlib/metrics.sock";
      TARGET          = "http://127.0.0.1:${toString upstreamPort}";
      SERVE_ROBOTS_TXT = true;
    };
  };

  services.caddy.virtualHosts.${host}.extraConfig = ''
    reverse_proxy unix//run/anubis/anubis-redlib/anubis.sock
  '';
}
