{
  config,
  lib,
  pkgs,
  inputs,
  cosmicLib,
  ...
}:

{
  imports = [
    ./appearance.nix
    ./applets.nix
    ./compositor.nix
    ./panels.nix
    ./shortcuts.nix
    ./wallpapers.nix
  ];

  options = {
    cosmic-manager.enable = lib.mkEnableOption "cosmic-manager customisations";
  };

  config = lib.mkIf config.cosmic-manager.enable {
    wayland.desktopManager.cosmic.enable = true;
    cosmic-manager = {
      appearance.enable = lib.mkDefault true;
      applets.enable = lib.mkDefault true;
      compositor.enable = lib.mkDefault true;
      panels.enable = lib.mkDefault true;
      shortcuts.enable = lib.mkDefault true;
      wallpapers.enable = lib.mkDefault true;
    };
  };
}
