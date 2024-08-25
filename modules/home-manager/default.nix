{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./utilities
    ./web
    ./gaming
  ];
}
