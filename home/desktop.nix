{
  imports = [
    ./common.nix
  ];
  programs = {
    kitty = {
        enable = true;
        enableGitIntegration = true;
    };
  };
}