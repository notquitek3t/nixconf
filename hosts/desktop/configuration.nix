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
      hashTableSizeMB = 512;
      verbosity = "crit";
      extraOptions = [ "--loadavg-target" "8.0" ];
    };
  };

  networking.hostName = "TheBlackBox"; # Define your hostname.
  services.openssh.enable = true;
  virtualisation.vmware.host.enable = true;
  programs.steam.enable = true;

  users.users.k3t = {
    packages = with pkgs; [
      kodi
      anydesk
      bubblewrap
      fuse-overlayfs
      nicotine-plus
      lutris
      prismlauncher
      wineWowPackages.waylandFull
      virt-viewer
      winetricks
    ];
  };
}
