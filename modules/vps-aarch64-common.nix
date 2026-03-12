{ pkgs, ... }: {

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["x86_64-linux" "i386-linux"]; 

  #environment.systemPackages = with pkgs; [
  #];

  services.fail2ban.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  system.autoUpgrade = {
    operation = "boot";
    allowReboot = true;
    rebootWindow = { lower = "02:00"; upper = "05:00"; };
  };
}
