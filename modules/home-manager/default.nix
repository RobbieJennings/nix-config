{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
    ./utilities
    ./web
    ./gaming
    ./photography
    ./development
    ./plasma-manager
    ./cosmic-manager
    ./secrets
  ];

  config = {
    home.packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
    ];
  };
}
