{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    networking.enable = lib.mkEnableOption "networking using networkmanager";
  };

  config = lib.mkIf config.networking.enable {
    networking.networkmanager.enable = true;
  };
}
