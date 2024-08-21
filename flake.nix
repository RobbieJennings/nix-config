{
  description = "Robbie's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    nixpkgs-unstable = {
       url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
    inherit (self) outputs;
    system = "x86_64-linux";
    specialArgs = { inherit inputs outputs; };
    defaults = [
      home-manager.nixosModules.home-manager
      {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs outputs; };
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [
          outputs.overlays.additions
          outputs.overlays.modifications
          outputs.overlays.unstable-packages
        ];
      }
    ];
  in {
    overlays = import ./overlays { inherit inputs outputs; };
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = {
      xps15 = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = defaults ++ [
          ./hosts/xps15
          ./users/robbie
        ];
      };
    };
  };
}
