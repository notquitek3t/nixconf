{ pkgs, ... }: {
  networking.hostName = "htpc";

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" "input" ];
  };

  # Kodi — run as a dedicated user session
  services.xserver.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "user";
  };
  services.xserver.desktopManager.kodi.enable = true;

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = false;
    pulse.enable = true;
  };

  hardware.opengl.enable = true;
}
