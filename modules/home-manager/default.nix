{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./utilities
    ./web
    ./gaming
    ./plasma
  ];
}
