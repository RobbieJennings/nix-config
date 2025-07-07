{
  config,
  lib,
  pkgs,
  inputs,
  cosmicLib,
  ...
}:

{
  options = {
    cosmic-manager.shortcuts.enable = lib.mkEnableOption "cosmic-manager shortcuts customisations";
  };

  config = lib.mkIf config.cosmic-manager.shortcuts.enable {
    wayland.desktopManager.cosmic.shortcuts = [
      {
        action = cosmicLib.cosmic.mkRON "enum" "Minimize";
        key = "Super+Shift+M";
      }
    ];
  };
}
