{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.stylix.homeManagerModules.stylix
    ./utilities
    ./web
    ./gaming
    ./desktop-customisations
  ];
}
