{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    web.ktorrent.enable = lib.mkEnableOption "ktorrent client";
  };

  config = lib.mkIf config.web.ktorrent.enable {
    services.flatpak.packages = [
      {
        appId = "org.kde.ktorrent";
        origin = "flathub";
      }
    ];
  };
}
