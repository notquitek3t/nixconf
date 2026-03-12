{ config, pkgs, lib, ... }:

let
  domain       = "frontendfriendly.xyz";
  host         = "dumb.${domain}";
  upstreamPort = 5555;
in
{
  virtualisation.oci-containers.containers.dumb = {
    image = "ghcr.io/rramiachraf/dumb:latest";
    autoStart = true;
    ports = [ "127.0.0.1:${toString upstreamPort}:5555" ];
    # environment = { ... } if Dumb needs configuration
  };

  services.anubis.instances.dumb = {
    enable = true;
  settings = {
    BIND         = "/run/anubis/anubis-dumb/anubis.sock";
    METRICS_BIND = "/run/anubis/anubis-dumb/metrics.sock";
      TARGET          = "http://127.0.0.1:${toString upstreamPort}";
      SERVE_ROBOTS_TXT = true;
    };
  };

  services.caddy.virtualHosts.${host}.extraConfig = ''
    reverse_proxy unix//run/anubis/anubis-dumb/anubis.sock
  '';
}
