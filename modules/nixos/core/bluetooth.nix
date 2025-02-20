{ config, lib, pkgs, inputs, ... }:

{
  options = { bluetooth.enable = lib.mkEnableOption "enables bluetooth"; };

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = lib.mkDefault true;
  };
}
