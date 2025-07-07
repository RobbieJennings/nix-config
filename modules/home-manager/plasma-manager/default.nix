{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./input.nix
    ./look-and-feel.nix
    ./panels.nix
    ./wallpaper.nix
  ];

  options = {
    plasma-manager.enable = lib.mkEnableOption "plasma-manager customisations";
  };

  config = lib.mkIf config.plasma-manager.enable {
    programs.plasma.enable = true;
    plasma-manager = {
      input.enable = lib.mkDefault true;
      look-and-feel.enable = lib.mkDefault true;
      panels.enable = lib.mkDefault true;
      wallpaper.enable = lib.mkDefault true;
    };
  };
}
