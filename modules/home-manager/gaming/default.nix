{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./heroic.nix
    ./lutris.nix
    ./prism.nix
  ];

  options = {
    gaming.enable = lib.mkEnableOption "enables all gaming clients";
  };

  config = lib.mkIf config.web.enable {
    gaming.heroic.enable = lib.mkDefault true;
    gaming.lutris.enable = lib.mkDefault true;
    gaming.prism.enable = lib.mkDefault true;
  };
}
