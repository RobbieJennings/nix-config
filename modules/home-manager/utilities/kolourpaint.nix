{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.kolourpaint.enable = lib.mkEnableOption "kolourpaint drawing app";
  };

  config = lib.mkIf config.utilities.kolourpaint.enable {
    services.flatpak.packages = [
      {
        appId = "org.kde.kolourpaint";
        origin = "flathub";
      }
    ];
  };
}
