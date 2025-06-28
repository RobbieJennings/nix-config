{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    photography.gimp.enable = lib.mkEnableOption "gimp editing app";
  };

  config = lib.mkIf config.photography.gimp.enable {
    services.flatpak.packages = [
      {
        appId = "org.gimp.GIMP";
        origin = "flathub";
      }
    ];
  };
}
