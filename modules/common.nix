{ pkgs, ... }: {
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  # auto upgrade from your public repo
  system.autoUpgrade = {
    enable = true;
    flake = "github:notquitek3t/nixconf";  # replace with your github username
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # networking
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    caligula
    openssl
    topgrade
    htop
    mosh
    btop
    wget2
    python314
  ];

  users.users.k3t = {
    description = "Kai Moore";
    isNormalUser = true;
    extraGroups = [ "audio" "video" "bluetooth" "wheel" "input" "networkmanager" ];
    initialPassword = "password";
    linger = true;
  };

  # locale / time — adjust as needed
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.stateVersion = "25.11";
}
