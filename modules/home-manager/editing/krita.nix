{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    editing.krita.enable = lib.mkEnableOption "krita editing app";
  };

  config = lib.mkIf config.editing.krita.enable {
    services.flatpak.packages = [
      {
        appId = "org.kde.krita";
        origin = "flathub";
      }
    ];
  };
}
