{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop.printing.enable = lib.mkEnableOption "enables printing using CUPS";
  };

  config = lib.mkIf config.desktop.printing.enable {
    services.printing.enable = lib.mkDefault true;
  };
}
