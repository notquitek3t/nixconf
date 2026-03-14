{ config, lib, pkgs, ... }:

{
  services.vaultwarden = {
      enable = true;
      backupDir = "/var/local/vaultwarden/backup";
      # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
      # be aware that this file must be created by hand (or via secrets management like sops)
      environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
      config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://bitwarden.k3t.dev";
        SIGNUPS_ALLOWED = true;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
      };
  };
  services.caddy.virtualHosts."bitwarden.k3t.dev".extraConfig = ''
    encode zstd gzip

    reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up X-Real-IP {remote_host}
    }
  '';
}
