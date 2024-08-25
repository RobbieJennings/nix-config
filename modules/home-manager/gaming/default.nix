{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./steam.nix
    ./heroic.nix
    ./lutris.nix
  ];

  options = {
    gaming.enable = lib.mkEnableOption "enables all gaming clients";
  };

  config = lib.mkIf config.web.enable {
    gaming.steam.enable = lib.mkDefault true;
    gaming.heroic.enable = lib.mkDefault true;
    gaming.lutris.enable = lib.mkDefault true;
  };
}
