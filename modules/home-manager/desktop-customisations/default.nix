{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./plasma-manager.nix
    ./stylix.nix
  ];

  options = {
    desktop-customisations.enable = lib.mkEnableOption "enables all desktop customisations";
  };

  config = lib.mkIf config.desktop-customisations.enable {
    desktop-customisations.plasma-manager.enable = lib.mkDefault true;
    desktop-customisations.stylix.enable = lib.mkDefault true;
  };
}
