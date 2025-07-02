{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    firmware-update.enable = lib.mkEnableOption "fwupd";
  };

  config = lib.mkIf config.firmware-update.enable {
    services.fwupd.enable = true;
  };
}
