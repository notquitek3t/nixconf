{ config, pkgs, lib, ... }:

{
  users.users.caddy.extraGroups = [ config.users.groups.anubis.name ];

  # hacky fix since ssl was broken
  
  services.caddy.virtualHosts."frontendfriendly.xyz".extraConfig = ''
    root /var/www/frontendfriendly.xyz
    file_server
    handle /webhook/828e8c10-af83-4a9b-a7ee-1b687ba12adc {
      reverse_proxy https://n8n.teamsds.net {
        transport http {
          tls_insecure_skip_verify
        }
        header_up Host n8n.teamsds.net
      }
    }
    handle /webhook-test/828e8c10-af83-4a9b-a7ee-1b687ba12adc {
      reverse_proxy https://n8n.teamsds.net {
        transport http {
          tls_insecure_skip_verify
        }
        header_up Host n8n.teamsds.net
      }
    }

  '';

}
