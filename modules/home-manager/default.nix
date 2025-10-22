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
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
    inputs.stylix.homeModules.stylix
    ./utilities
    ./backup
    ./web
    ./gaming
    ./editing
    ./development
    ./plasma-manager
    ./cosmic-manager
    ./secrets
    ../nixos/core/theme.nix
  ];

  config = {
    home.packages = [
      config.theme.fonts.interface.package
      config.theme.fonts.monospace.package
      config.theme.fonts.emoji.package
    ];
  };
}
