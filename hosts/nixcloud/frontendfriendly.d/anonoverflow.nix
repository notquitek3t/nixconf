{ config, pkgs, lib, ... }:

let
  domain       = "frontendfriendly.xyz";
  host         = "stackoverflow.${domain}";
  upstreamPort = 7101;

  # 1) Fetch source from GitHub
  anonymousOverflowSrc = pkgs.fetchFromGitHub {
    owner  = "httpjamesm";
    repo   = "AnonymousOverflow";
    rev    = "v1.13.0";  # pin a release tag
    # TODO: replace with real hash after first build
    sha256 = "sha256-hvcOJctvNswEws+cCoeGQSvFzZvnThhKk3fJ7TnNulY=";
  };

  # 2) Build the Go binary
  anonymousOverflowPkg = pkgs.buildGoModule {
    pname   = "anonymousoverflow";
    version = "1.13.0";

    src = anonymousOverflowSrc;

    # code is at repo root
    subPackages = [ "." ];

    # TODO: replace with real vendor hash after first build
    vendorHash = "sha256-P3kUGFJhj/pTNeVTwtg4IqhoHBH9rROfkr+ZsrUtmdo=";
  };
in
{
  containers.anonymousoverflow = {
    autoStart = true;

    # Simple veth connection between host and container
    privateNetwork = true;
    hostAddress    = "10.250.0.1";
    localAddress   = "10.250.0.2";

    # Rootfs is generated from this NixOS config:
    config = { config, pkgs, ... }:

      let
        # 1) Fetch AnonymousOverflow source
        anonymousOverflowSrc = pkgs.fetchFromGitHub {
          owner  = "httpjamesm";
          repo   = "AnonymousOverflow";
          # Pin some tag or commit
          rev    = "v1.13.0";
          # TODO: replace with real hash after first build
          sha256 = "sha256-hvcOJctvNswEws+cCoeGQSvFzZvnThhKk3fJ7TnNulY=";
        };

        # 2) Build the Go binary
        anonymousOverflowPkg = pkgs.buildGoModule {
          pname   = "anonymousoverflow";
          version = "1.13.0";

          src = anonymousOverflowSrc;

          # repo root
          subPackages = [ "." ];

          # TODO: replace with real vendor hash after first build
          vendorHash = "sha256-P3kUGFJhj/pTNeVTwtg4IqhoHBH9rROfkr+ZsrUtmdo=";
        };
      in
      {
        # Set this to match your host’s stateVersion
        system.stateVersion = "24.11";

        # Optional but nice: container firewall allowing port 80
        networking.firewall.allowedTCPPorts = [ 80 ];

        systemd.services.anonymousoverflow = {
          description = "AnonymousOverflow StackOverflow frontend (container)";
          wantedBy    = [ "multi-user.target" ];
          after       = [ "network-online.target" ];
          wants       = [ "network-online.target" ];

          serviceConfig = {
            # Runs as root in container; that’s fine here, it needs port 80
            ExecStart = "${anonymousOverflowPkg}/bin/anonymousoverflow";

            Restart = "always";
            RestartSec = 3;
          };
        };

        # If AO needs env vars / config, set them here:
        # systemd.services.anonymousoverflow.serviceConfig.Environment = [
        #   "PORT=80"
        #   "BIND_ADDR=0.0.0.0"
        # ];
      };
  };

  #################################
  ## Anubis in front of it       ##
  #################################

  services.anubis.instances.anonymousoverflow = {
    enable = true;

    settings = {
      # Must use this prefix form: /run/anubis/anubis-<name>/...
      BIND         = "/run/anubis/anubis-anonymousoverflow/anubis.sock";
      METRICS_BIND = "/run/anubis/anubis-anonymousoverflow/metrics.sock";

      # If you keep the default :8080:
      # TARGET = "http://127.0.0.1:8080";

      # If you configure the app to listen on 127.0.0.1:${upstreamPort}:
      TARGET           = "http://10.250.0.2:${toString upstreamPort}";

      SERVE_ROBOTS_TXT = true;
    };
  };

  #################################
  ## Caddy vhost                 ##
  #################################

  services.caddy.virtualHosts.${host}.extraConfig = ''
    reverse_proxy unix//run/anubis/anubis-anonymousoverflow/anubis.sock
  '';
}
