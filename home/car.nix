{
  imports = [
    ./common.nix
  ];
  home.file = {
    ".car/init.sh".source = ../hosts/pi-car/scripts/init.sh;
  };
  programs.zsh.loginExtra = "bash /home/k3t/.car/init.sh";
}