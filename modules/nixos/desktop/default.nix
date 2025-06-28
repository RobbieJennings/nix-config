{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./printing.nix
    ./scanning.nix
    ./kde-plasma.nix
    ./kde-connect.nix
    ./steam.nix
    ./virtualisation.nix
    ./cosmic-desktop.nix
  ];

  options = {
    desktop.enable = lib.mkEnableOption "default desktop modules";
  };

  config = lib.mkIf config.desktop.enable {
    services.flatpak.enable = lib.mkDefault true;
    desktop = {
      audio.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
      printing.enable = lib.mkDefault true;
      scanning.enable = lib.mkDefault true;
      kde-plasma.enable = lib.mkDefault false;
      kde-connect.enable = lib.mkDefault true;
      steam.enable = lib.mkDefault true;
      virtualisation.enable = lib.mkDefault true;
      cosmic-desktop.enable = lib.mkDefault true;
    };
  };
}
