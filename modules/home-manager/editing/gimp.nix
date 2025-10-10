{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    editing.gimp.enable = lib.mkEnableOption "gimp editing app";
  };

  config = lib.mkIf config.editing.gimp.enable {
    services.flatpak.packages = [
      {
        appId = "org.gimp.GIMP";
        origin = "flathub";
      }
    ];
  };
}
