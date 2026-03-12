{ config, pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;   # optional; lets you use `docker` CLI
  };

  systemd.services.minecraft-container = {
    description = "Minecraft Server Container (GraalVM JVM 21)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.podman}/bin/podman run \
          --rm \
          --name minecraft-server \
          -v /var/lib/minecraft:/data \
          -p 25565:25565 \
          -p 24454:24454/udp \
          ghcr.io/graalvm/graalvm-community:25 \
          /data/run.sh
      '';
      ExecStop = "${pkgs.podman}/bin/podman stop minecraft-server";
      Restart = "always";
      RestartSec = "10s";
    };

    # Ensure the directory exists
    preStart = ''
      mkdir -p /var/lib/minecraft
    '';
    wantedBy = [ "multi-user.target" ];
  };

  # Give Podman permission to access persistent storage
  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft 0755 root root"
  ];
}
