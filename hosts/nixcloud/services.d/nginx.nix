{ config, lib, pkgs, ... }:


{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."k3t.dev" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/k3t.dev";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "k3t@k3t.dev";
  };
}
