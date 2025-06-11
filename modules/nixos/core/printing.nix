{ config, lib, pkgs, inputs, ... }:

{
  options = {
    printing.enable = lib.mkEnableOption "enables printing using CUPS";
  };

  config = lib.mkIf config.networking.enable {
    services.printing.enable = lib.mkDefault true;
  };
}
