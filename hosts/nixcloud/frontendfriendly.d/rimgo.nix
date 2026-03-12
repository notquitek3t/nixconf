{ config, pkgs, lib, ... }:

let
  domain       = "frontendfriendly.xyz";
  host         = "rimgo.${domain}";
  upstreamPort = 7104;
in
{
  services.rimgo = {
    enable = true;
    # Rimgo uses a port in its settings; set it to local only
    settings = {
      ADDRESS = "127.0.0.1";
      PORT    = upstreamPort;
    };
  };

  services.anubis.instances.rimgo = {
    enable = true;
  settings = {
    BIND         = "/run/anubis/anubis-rimgo/anubis.sock";
    METRICS_BIND = "/run/anubis/anubis-rimgo/metrics.sock";
      TARGET          = "http://127.0.0.1:${toString upstreamPort}";
      SERVE_ROBOTS_TXT = true;
    };
  };

  services.caddy.virtualHosts.${host}.extraConfig = ''
    reverse_proxy unix//run/anubis/anubis-rimgo/anubis.sock
  '';
}
