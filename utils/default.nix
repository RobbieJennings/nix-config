{ inputs, ... }:

let
  overlays = import ../overlays { inherit inputs; };
  nixosModules = import ../modules/nixos;
  homeManagerModules = import ../modules/home-manager;
  defaults = [
    inputs.home-manager.nixosModules.home-manager
    {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      nix.settings.auto-optimise-store = true;
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        overlays.additions
        overlays.modifications
        overlays.unstable-packages
      ];
      users.mutableUsers = false;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs homeManagerModules; };
    }
  ];
in {
  mkSystem = system: modules:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs nixosModules; };
      modules = defaults ++ modules;
    };

  mkPlatform = platformPath:
    let platform = import platformPath;
    in with platform; mkPlatform;

  mkHost = hostPath: hostname:
    let host = import hostPath;
    in with host; mkHost hostname;

  mkUser = userPath: username:
    let user = import userPath;
    in with user; mkUser username;

  mkOptionsDoc = system:
    inputs.nixpkgs.legacyPackages.${system}.callPackage ./options-doc.nix { };
}
