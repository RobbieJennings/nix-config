{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    desktop.bluetooth.enable = lib.mkEnableOption "bluetooth";
  };

  config = lib.mkIf config.desktop.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = lib.mkDefault true;
  };
}
