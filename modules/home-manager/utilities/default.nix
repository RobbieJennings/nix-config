{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./discover.nix
    ./calculator.nix
    ./camera.nix
    ./screenshot.nix
    ./remote-desktop.nix
  ];

  options = {
    utilities.enable = lib.mkEnableOption "enables all utility applications";
  };

  config = lib.mkIf config.utilities.enable {
    utilities.discover.enable = lib.mkDefault true;
    utilities.screenshot.enable = lib.mkDefault true;
    utilities.camera.enable = lib.mkDefault true;
    utilities.calculator.enable = lib.mkDefault true;
    utilities.remoteDesktop.enable = lib.mkDefault true;
  };
}
