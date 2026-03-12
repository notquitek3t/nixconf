# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    (lib.filesystem.listFilesRecursive ./services.d)
    ++ [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    
  networking.hostName = "nixcloud"; # Define your hostname.


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    steward = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        btop htop
        nano
      ];
    };
    kuro = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        btop htop
        nano
      ];
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  #environment.systemPackages = with pkgs; [
  #   wget
  #];


  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 25565 4433 9971 ];
  networking.firewall.allowedUDPPorts = [ 24454 4433 9971 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
