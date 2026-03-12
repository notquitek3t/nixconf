{
  imports = [
    ./common.nix
  ];
  home.file = {
    #".profile".text = ''
    #bash /home/k3t/.car/init.sh
    #'';
    ".car/init.sh".source = ../hosts/pi-car/scripts/init.sh;
  };
  programs.zsh.loginExtra = "bash /home/k3t/.car/init.sh";
}