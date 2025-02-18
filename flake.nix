{
  description = "Robbie's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    nixpkgs-unstable = {
       url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { ... }:
  let
    system = "x86_64-linux";
    utils = import ./utils { inherit inputs; };
  in with utils;
  {
    formatter.${system} = inputsnixpkgs.legacyPackages.${system}.nixfmt;
    packages.${system}.generateOptionsDoc = mkOptionsDoc system;
    nixosConfigurations = {
      xps15 = mkSystem system
        [
          { secrets.enable = true; }
          (mkPlatform ./platforms/desktop)
          (mkHost ./hosts/xps15 "xps15")
          (mkUser ./users/desktop-admin "robbie")
          (mkUser ./users/desktop-user "clare")
        ];

      vmDesktop = mkSystem system
        [
          (mkPlatform ./platforms/desktop)
          (mkHost ./hosts/xps15 "vm_desktop")
          (mkUser ./users/desktop-admin "robbie")
          (mkUser ./users/desktop-user "clare")
        ];

      vmServer = mkSystem system
        [
          (mkPlatform ./platforms/server)
          (mkHost ./hosts/vm "vm_server")
          (mkUser ./users/server-admin "robbie")
        ];
    };
  };
}
