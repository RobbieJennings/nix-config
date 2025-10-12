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
      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
      ];
      pkgs = forAllSystems (system: import inputs.nixpkgs { inherit system; });
      utils = import ./utils { inherit inputs; };
    in
    with utils;
    {
      formatter = forAllSystems (system: pkgs.${system}.nixfmt-tree);

      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
            flake-checker.enable = true;
            statix.enable = true;
            nil.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });

      packages = forAllSystems (system: {
        nixosOptionsDoc = pkgs.${system}.callPackage ./utils/nixos-options-doc.nix { };
        homeManagerOptionsDoc = pkgs.${system}.callPackage ./utils/home-manager-options-doc.nix { };
      });

      nixosConfigurations = {
        xps15 = mkSystem "x86_64-linux" [
          { secrets.enable = true; }
          { impermanence.enable = true; }
          (mkPlatform {
            path = ./platforms/desktop;
          })
          (mkHost {
            path = ./hosts/xps15;
            hostname = "xps15";
          })
          (mkUser {
            path = ./users/desktop-admin;
            username = "robbie";
            gitUserName = "robbiejennings";
            gitUserEmail = "robbie.jennings97@gmail.com";
          })
        ];

        vmServer = mkSystem "x86_64-linux" [
          (mkPlatform {
            path = ./platforms/server;
          })
          (mkHost {
            path = ./hosts/vm;
            hostname = "vmServer";
          })
          (mkUser {
            path = ./users/server-admin;
            username = "robbie";
            gitUserName = "robbiejennings";
            gitUserEmail = "robbie.jennings97@gmail.com";
          })
        ];

        vmDesktop = mkSystem "x86_64-linux" [
          { impermanence.enable = true; }
          { auto-upgrade.enable = false; }
          { server.enable = true; }
          (mkPlatform {
            path = ./platforms/desktop;
          })
          (mkHost {
            path = ./hosts/vm;
            hostname = "vmDesktop";
          })
          (mkUser {
            path = ./users/desktop-admin;
            username = "robbie";
            gitUserName = "robbiejennings";
            gitUserEmail = "robbie.jennings97@gmail.com";
          })
        ];
      };
    };
}
