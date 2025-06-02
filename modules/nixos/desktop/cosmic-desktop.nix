{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop.cosmic-desktop.enable =
      lib.mkEnableOption "enables cosmic desktop environment";
  };

  config = lib.mkIf config.desktop.cosmic-desktop.enable {
    services.displayManager.cosmic-greeter.enable = lib.mkDefault true;
    services.desktopManager.cosmic.enable = lib.mkDefault true;
  };
}
