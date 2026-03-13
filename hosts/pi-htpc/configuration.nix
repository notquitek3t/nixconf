{ pkgs, ... }:

let
  kodi-with-addons = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
    inputstream-adaptive
    bluetooth-manager
  ]);
in

{
  networking.hostName = "htpc";

  # HDMI CEC
  nixpkgs.overlays = [
    (self: super: { libcec = super.libcec.override { withLibraspberrypi = true; }; })
  ];
  environment.systemPackages = with pkgs; [
    libcec
  ];
  services.udev.extraRules = ''
    # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
    KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
  '';
  systemd.sockets."cec-client" = {
    after = [ "dev-vchiq.device" ];
    bindsTo = [ "dev-vchiq.device" ];
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenFIFO = "/run/cec.fifo";
      SocketGroup = "video";
      SocketMode = "0660";
    };
  };
  systemd.services."cec-client" = {
    after = [ "dev-vchiq.device" ];
    bindsTo = [ "dev-vchiq.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''${pkgs.libcec}/bin/cec-client -d 1'';
      ExecStop = ''/bin/sh -c "echo q > /run/cec.fifo"'';
      StandardInput = "socket";
      StandardOutput = "journal";
      Restart="no";
    };
  };

  # Kodi - run under Wayland
  services.cage.user = "k3t";
  services.cage.extraArguments = [ "-m" "last" ];
  services.cage.program = "${kodi-with-addons}/bin/kodi-standalone";
  services.cage.enable = true;  

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = false;
    pulse.enable = true;
  };

  # gpu
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.graphics.enable = true;
}
