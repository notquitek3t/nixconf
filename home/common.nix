{ config, ... }:

{
  imports = [
    ./cfg/git.nix
    ./cfg/htop.nix
    ./cfg/zsh.nix
  ];

  home.username = "k3t";
  home.homeDirectory = "/home/k3t";
  home.stateVersion = "25.11";
}