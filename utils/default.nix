{ inputs, ... }:

let
  overlays = import ../overlays { inherit inputs; };
  nixosModules = import ../modules/nixos;
  homeManagerModules = import ../modules/home-manager;
  defaults = [
    inputs.home-manager.nixosModules.home-manager
    {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
      services.flatpak.enable = true;
    }
  ];
in
{
  mkSystem = system: modules:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs nixosModules; };
      modules = defaults ++ modules;
    };
}
