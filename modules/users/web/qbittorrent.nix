{
  inputs,
  ...
}:
{
  flake.modules.homeManager.qbittorrent =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        qbittorrent.enable = lib.mkEnableOption "qbittorrent client";
      };

      config = lib.mkIf config.qbittorrent.enable {
        services.flatpak.packages = [
          {
            appId = "org.qbittorrent.qBittorrent";
            origin = "flathub";
          }
        ];
      };
    };
}
