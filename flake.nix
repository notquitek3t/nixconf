{
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, impermanence, nixos-hardware, home-manager, ... }:
  let
    mkHost = system: modules: nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = { inherit impermanence nixos-hardware; };
    };

    mkPiImage = modules: (nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit impermanence nixos-hardware home-manager; };
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        impermanence.nixosModules.impermanence
        nixos-hardware.nixosModules.raspberry-pi-4
        home-manager.nixosModules.home-manager
      ] ++ modules;
    }).config.system.build.sdImage;
  in {
    nixosConfigurations = {
      "TheBlackBox" = mkHost "x86_64-linux" [
        ./modules/common.nix
        ./modules/desktop-common.nix
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.k3t = ./home/desktop.nix;
        }
      ];
      "T14" = mkHost "x86_64-linux" [
        ./modules/common.nix
        ./modules/desktop-common.nix
        ./hosts/laptop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.k3t = ./home/desktop.nix;
        }
      ];
      "nixcloud" = mkHost "x86_64-linux" [
        ./modules/common.nix
        ./modules/vps-aarch64-common.nix
        ./hosts/nixcloud/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.k3t = ./home/vps.nix;
        }
      ];
      Pontiac-G5 = mkHost "aarch64-linux" [
        impermanence.nixosModules.impermanence
        nixos-hardware.nixosModules.raspberry-pi-4
        ./modules/common.nix
        ./modules/pi-common.nix
        ./hosts/pi-car/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.k3t = ./home/car.nix;
        }
      ];
      pi-htpc = mkHost "aarch64-linux" [
        nixos-hardware.nixosModules.raspberry-pi-4
        ./modules/common.nix
        ./modules/pi-common.nix
        ./hosts/pi-htpc/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.k3t = ./home/desktop.nix;
        }
      ];
    };

    # SD card images
    images = {
      pi-car = mkPiImage [
        ./modules/common.nix
        ./modules/pi-common.nix
        ./hosts/pi-car/configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.k3t = ./home/car.nix;
        }
      ];
      pi-htpc = mkPiImage [
        ./modules/common.nix
        ./modules/pi-common.nix
        ./hosts/pi-htpc/configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.k3t = ./home/desktop.nix;
        }
      ];
    };
  };
}
