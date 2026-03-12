{ config, lib, pkgs, ... }:


{
  services.caddy = {
    enable = true;
    virtualHosts."k3t.dev".extraConfig = ''
      encode zstd gzip
      root /var/www/k3t.dev/
      file_server browse
    '';
  };

}
