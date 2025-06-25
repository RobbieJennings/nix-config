{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    photography.krita.enable = lib.mkEnableOption "enables krita editing app";
  };

  config = lib.mkIf config.photography.krita.enable {
    services.flatpak.packages = [
      {
        appId = "org.kde.krita";
        origin = "flathub";
      }
    ];
  };
}
