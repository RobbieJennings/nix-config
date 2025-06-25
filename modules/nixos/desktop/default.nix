{ config, lib, pkgs, inputs, ... }:

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
    desktop.enable = lib.mkEnableOption "enables default desktop modules";
  };

  config = lib.mkIf config.desktop.enable {
    services.flatpak.enable = lib.mkDefault true;
    desktop.audio.enable = lib.mkDefault true;
    desktop.bluetooth.enable = lib.mkDefault true;
    desktop.printing.enable = lib.mkDefault true;
    desktop.scanning.enable = lib.mkDefault true;
    desktop.kde-plasma.enable = lib.mkDefault false;
    desktop.kde-connect.enable = lib.mkDefault true;
    desktop.steam.enable = lib.mkDefault true;
    desktop.virtualisation.enable = lib.mkDefault true;
    desktop.cosmic-desktop.enable = lib.mkDefault true;
  };
}
