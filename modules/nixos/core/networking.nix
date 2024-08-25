{ config, lib, pkgs, inputs, ... }:

{
  options = {
    networking.enable = lib.mkEnableOption "enables networking using networkmanager and CUPS";
  };

  config = lib.mkIf config.networking.enable {
    networking.networkmanager.enable = lib.mkDefault true;
    services.printing.enable = lib.mkDefault true;
  };
}
