{ config, lib, pkgs, ... }:


{
  services.gonic = {
    enable = true;
    settings = {
      music-path = [
        "/home/k3t/Music"
      ];
      playlists-path = "/home/k3t/Playlists";
      podcast-path  = "/home/k3t/Podcasts";
    };
  };

  services.nginx.virtualHosts."gonic.k3t.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4747";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}