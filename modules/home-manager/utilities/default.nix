{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./discover.nix
    ./calculator.nix
    ./camera.nix
    ./screenshot.nix
    ./vlc.nix
    ./remote-desktop.nix
    ./office.nix
    ./spotify.nix
    ./calibre.nix
  ];

  options = {
    utilities.enable = lib.mkEnableOption "enables all utility applications";
  };

  config = lib.mkIf config.utilities.enable {
    utilities.discover.enable = lib.mkDefault true;
    utilities.screenshot.enable = lib.mkDefault true;
    utilities.vlc.enable = lib.mkDefault true;
    utilities.camera.enable = lib.mkDefault true;
    utilities.calculator.enable = lib.mkDefault true;
    utilities.remoteDesktop.enable = lib.mkDefault true;
    utilities.office.enable = lib.mkDefault true;
    utilities.spotify.enable = lib.mkDefault true;
    utilities.calibre.enable = lib.mkDefault true;
  };
}
