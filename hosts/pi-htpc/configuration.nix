{ pkgs, ... }:

let
  kodi-with-addons = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
    inputstream-adaptive
    inputstream-ffmpegdirect
    inputstream-rtmp 
    inputstreamhelper
    bluetooth-manager
    vfs-sftp
    vfs-rar
    vfs-libarchive
    urllib3
    upnext
    trakt
    trakt-module
    sponsorblock
    invidious
    simplecache
    libretro
    libretro-snes9x
    libretro-nestopia
    jellycon
    archive_tool
    joystick
    keymap
    osmc-skin
    jellyfin
    visualization-projectm
    visualization-goom
    visualization-fishbmc
    visualization-matrix
  ]);
in

{
  networking.hostName = "htpc";

  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
    # hdmi cec
    libcec
  ];
  nixpkgs.overlays = [
    (self: super: { libcec = super.libcec.override { withLibraspberrypi = true; }; })
  ];

  services.udev.extraRules = ''
    # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
    KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
  '';
  #systemd.sockets."cec-client" = {
  #  after = [ "dev-vchiq.device" ];
  #  bindsTo = [ "dev-vchiq.device" ];
  #  wantedBy = [ "sockets.target" ];
  #  socketConfig = {
  #    ListenFIFO = "/run/cec.fifo";
  #    SocketGroup = "video";
  #    SocketMode = "0660";
  #  };
  #};
  #systemd.services."cec-client" = {
  #  after = [ "dev-vchiq.device" ];
  #  bindsTo = [ "dev-vchiq.device" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    ExecStart = ''${pkgs.libcec}/bin/cec-client -d 1'';
  #    ExecStop = ''/bin/sh -c "echo q > /run/cec.fifo"'';
  #    StandardInput = "socket";
  #    StandardOutput = "journal";
  #    Restart="no";
  #  };
  #};

  # kde connect for remote ctrl
  programs.kdeconnect.enable = true;

  # kodi wayland v1
  ##services.cage.user = "k3t";
  ##services.cage.extraArguments = [ "-d" "-s" ];
  ##services.cage.program = "${kodi-with-addons}/bin/kodi-standalone";
  ##services.cage.enable = true;

  # kodi x11
  ##services.xserver.enable = true;
  ##services.xserver.desktopManager.kodi.enable = true;
  ##services.xserver.desktopManager.kodi.package = kodi-with-addons;
  ##services.xserver.displayManager.lightdm.greeter.enable = false;
  ##services.displayManager.autoLogin.user = "k3t";

  # kodi wayland, v2
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;    
      user = "k3t"; # Replace with the desired user
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

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
