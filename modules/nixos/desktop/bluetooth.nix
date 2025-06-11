{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop.bluetooth.enable = lib.mkEnableOption "enables bluetooth";
  };

  config = lib.mkIf config.desktop.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = lib.mkDefault true;
  };
}
