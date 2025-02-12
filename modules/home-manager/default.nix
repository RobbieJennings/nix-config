{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.stylix.homeManagerModules.stylix
    ./utilities
    ./web
    ./gaming
    ./photography
    ./desktop-customisations
    ./secrets
  ];
}
