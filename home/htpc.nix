
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
  imports = [
    ./common.nix
    ./cfg/kitty.nix
    ./cfg/gtk.nix
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "${kodi-with-addons}/bin/kodi-standalone";}
      ];
    };
  };
}