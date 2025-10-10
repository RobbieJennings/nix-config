{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    editing.kdenlive.enable = lib.mkEnableOption "kdenlive editing app";
  };

  config = lib.mkIf config.editing.kdenlive.enable {
    services.flatpak.packages = [
      {
        appId = "org.kde.kdenlive";
        origin = "flathub";
      }
    ];
  };
}
