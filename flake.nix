{
  description = "Robbie's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
      utils = import ./utils { inherit inputs; };
    in
    with utils;
    {
      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
            flake-checker.enable = true;
            statix.enable = true;
            nil.enable = true;
          };
        };
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      };

      packages.${system} = {
        nixosOptionsDoc = pkgs.callPackage ./utils/nixos-options-doc.nix { };
        homeManagerOptionsDoc = pkgs.callPackage ./utils/home-manager-options-doc.nix { };
      };

      nixosConfigurations = {
        xps15 = mkSystem system [
          { secrets.enable = true; }
          { impermanence.enable = true; }
          (mkPlatform ./platforms/desktop)
          (mkHost ./hosts/xps15 "xps15")
          (mkUser ./users/desktop-admin "robbie" "robbiejennings" "robbie.jennings97@gmail.com")
        ];

        vmServer = mkSystem system [
          (mkPlatform ./platforms/server)
          (mkHost ./hosts/vm "vmServer")
          (mkUser ./users/server-admin "robbie" "robbiejennings" "robbie.jennings97@gmail.com")
        ];

        vmDesktop = mkSystem system [
          { impermanence.enable = true; }
          { auto-upgrade.enable = false; }
          { server.enable = true; }
          (mkPlatform ./platforms/desktop)
          (mkHost ./hosts/vm "vmDesktop")
          (mkUser ./users/desktop-admin "robbie" "robbiejennings" "robbie.jennings97@gmail.com")
        ];
      };
    };
}
