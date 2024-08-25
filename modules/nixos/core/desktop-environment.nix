{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop-environment.enable = lib.mkEnableOption "enables plasma desktop environment";
  };

  config = lib.mkIf config.desktop-environment.enable {
    services.displayManager.sddm.enable = lib.mkDefault true;
    services.displayManager.sddm.wayland.enable = lib.mkDefault true;
    services.desktopManager.plasma6.enable = lib.mkDefault true;
  };
}
