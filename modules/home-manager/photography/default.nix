{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./vuescan.nix
    ./darktable.nix
    ./krita.nix
    ./gimp.nix
  ];

  options = {
    photography.enable = lib.mkEnableOption "enables all photography applications";
  };

  config = lib.mkIf config.utilities.enable {
    photography.vuescan.enable = lib.mkDefault true;
    photography.darktable.enable = lib.mkDefault true;
    photography.krita.enable = lib.mkDefault true;
    photography.gimp.enable = lib.mkDefault true;
  };
}
