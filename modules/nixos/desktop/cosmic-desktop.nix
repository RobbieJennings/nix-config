{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    desktop.cosmic-desktop.enable = lib.mkEnableOption "cosmic desktop environment";
  };

  config = lib.mkIf config.desktop.cosmic-desktop.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
    environment.systemPackages = [
      pkgs.cosmic-ext-calculator
    ];
  };
}
