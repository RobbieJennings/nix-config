{ config, lib, pkgs, inputs, ... }:

{
  options = {
    networking.enable =
      lib.mkEnableOption "enables networking using networkmanager";
  };

  config = lib.mkIf config.networking.enable {
    networking.networkmanager.enable = lib.mkDefault true;
  };
}
