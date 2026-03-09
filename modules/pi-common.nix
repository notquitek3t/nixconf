{ pkgs, ... }: {

  boot.initrd.allowMissingModules = true;
  boot.supportedFilesystems.zfs = false;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  fileSystems = {
    "/" = { device = "/dev/disk/by-label/NIXOS_SD"; fsType = "ext4"; };
  };
     

  # Pi 4 specific
  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      bluetooth.enable = true;
    };
  enableRedistributableFirmware = true;
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  # ssh so you can manage them remotely
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # auto upgrade on pis can reboot unattended
  system.autoUpgrade = {
    operation = "boot";
    allowReboot = true;
    rebootWindow = { lower = "02:00"; upper = "05:00"; };
  };
}
