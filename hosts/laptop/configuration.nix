# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  services.beesd.filesystems = {
    root = {
      spec = "LABEL=NixOS";
      hashTableSizeMB = 128;
      verbosity = "crit";
      extraOptions = [ "--loadavg-target" "1.5" ];
    };
  };

  networking.hostName = "T14"; # Define your hostname.
  services.openssh.enable = true;

  users.users.k3t = {
    packages = with pkgs; [
      anydesk
      virt-viewer
    ];
  };
}
