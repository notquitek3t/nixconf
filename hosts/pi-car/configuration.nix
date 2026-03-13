{ pkgs, ... }: {
  networking.hostName = "Pontiac-G5";
  console.enable = false;
  systemd.services = {
    "autovt@tty1" = {
      enable = true;
      restartIfChanged = false;
      description = "autologin service at tty1";
      after = [ "suppress-kernel-logging.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =  builtins.concatStringsSep " " ([
          "@${pkgs.utillinux}/sbin/agetty"
          "agetty --login-program ${pkgs.shadow}/bin/login"
          "--autologin k3t --noclear %I $TERM"
        ]);
        Restart = "always";
        Type = "idle";
      };
    };
    "suppress-kernel-logging" = {
      enable = true;
      restartIfChanged = false;
      description = "suppress kernel logging to the console";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.utillinux}/sbin/dmesg -n 1";
        Type = "oneshot";
      };
    };
  };

  # bluetooth - headless auto pair
  hardware.bluetooth.settings = {
    Policy.AutoEnable = true;
    General = {
      Name = "Pontiac G5";
      DiscoverableTimeout = 0;
      PairableTimeout = 0;
      Class = "0x200408";
    };
  };

  systemd.services.bluetooth-auto-pair = {
    description = "Bluetooth headless auto-pair agent";
    after = [ "bluetooth.service" ];
    wants = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez-tools}/bin/bt-agent -c NoInputNoOutput";
      Restart = "on-failure";
    };
  };

  # pipewire for audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = false;
    pulse.enable = true;
  };

  systemd.user.services.pipewire.wantedBy = [ "default.target" ];
  systemd.user.services.pipewire-pulse.wantedBy = [ "default.target" ];
}
