{ config, lib, pkgs, ... }:

{
    services.blocky = {
    enable = true;
    settings = {
      certFile = "/etc/nixos/dns.crt";
      keyFile =  "/etc/nixos/dns.key";
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
      ports = {
        dns = 53;
        tls = 853;
        http = 4000;
      };
      
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };

      #Enable Blocking of certain domains.
      blocking = {
        loading.refreshPeriod = "1h";
        denylists = {
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
          ];
          tracking = [
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
            "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
          ];
          sus = [
            "https://someonewhocares.org/hosts/zero/hosts"
            "https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt"
            "https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
            "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
            "https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt"
          ];
        };
        
        #Configure what block categories are used
        clientGroupsBlock = {
          default = [ "ads" "tracking" "sus" ];
        };
      };
    };
  };
}