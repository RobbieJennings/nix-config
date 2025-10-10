{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    editing.audacity.enable = lib.mkEnableOption "audacity editing app";
  };

  config = lib.mkIf config.editing.audacity.enable {
    services.flatpak.packages = [
      {
        appId = "org.audacityteam.Audacity";
        origin = "flathub";
      }
    ];
  };
}
