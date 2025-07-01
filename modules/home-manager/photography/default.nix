{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./vuescan.nix
    ./darktable.nix
    ./krita.nix
    ./gimp.nix
  ];

  options = {
    photography.enable = lib.mkEnableOption "all photography applications";
  };

  config = lib.mkIf config.photography.enable {
    photography = {
      vuescan.enable = lib.mkDefault true;
      darktable.enable = lib.mkDefault true;
      krita.enable = lib.mkDefault true;
      gimp.enable = lib.mkDefault true;
    };
  };
}
