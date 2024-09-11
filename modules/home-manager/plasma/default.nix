{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./plasma-manager.nix
  ];

  options = {
    plasma.enable = lib.mkEnableOption "enables plasma desktop tweaks";
  };

  config = lib.mkIf config.plasma.enable {
    plasma.plasma-manager.enable = lib.mkDefault true;
  };
}
