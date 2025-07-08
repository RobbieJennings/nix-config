{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    web.qbittorrent.enable = lib.mkEnableOption "qbittorrent client";
  };

  config = lib.mkIf config.web.qbittorrent.enable {
    services.flatpak.packages = [
      {
        appId = "org.qbittorrent.qBittorrent";
        origin = "flathub";
      }
    ];
  };
}
