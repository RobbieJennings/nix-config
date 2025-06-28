{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.camera.enable = lib.mkEnableOption "komoso camera";
  };

  config = lib.mkIf config.utilities.camera.enable {
    services.flatpak.packages = [
      {
        appId = "org.kde.kamoso";
        origin = "flathub";
      }
    ];
  };
}
