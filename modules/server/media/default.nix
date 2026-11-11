{
  inputs,
  ...
}:
{
  flake.modules.nixos.media-server =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.media-namespace
        inputs.self.modules.nixos.media-persistence
        inputs.self.modules.nixos.media-secrets
        inputs.self.modules.nixos.jellyfin
        inputs.self.modules.nixos.transmission
        inputs.self.modules.nixos.flaresolverr
        inputs.self.modules.nixos.prowlarr
        inputs.self.modules.nixos.radarr
        inputs.self.modules.nixos.sonarr
        inputs.self.modules.nixos.lidarr
        inputs.self.modules.nixos.seerr
        inputs.self.modules.nixos.calibre-web-automated
        inputs.self.modules.nixos.audiobookshelf
        inputs.self.modules.nixos.shelfmark
      ];

      options = {
        media-server.enable = lib.mkEnableOption "jellyfin, transmission and servarr services on k3s";
        secrets.media-server.enable = lib.mkEnableOption "jellyfin, transmission and servarr secrets";
      };

      config = lib.mkIf config.media-server.enable {
        media-server = {
          jellyfin.enable = lib.mkDefault true;
          transmission.enable = lib.mkDefault true;
          flaresolverr.enable = lib.mkDefault true;
          prowlarr.enable = lib.mkDefault true;
          radarr.enable = lib.mkDefault true;
          sonarr.enable = lib.mkDefault true;
          lidarr.enable = lib.mkDefault true;
          seerr.enable = lib.mkDefault true;
          calibre-web-automated.enable = lib.mkDefault true;
          audiobookshelf.enable = lib.mkDefault true;
          shelfmark.enable = lib.mkDefault true;
        };
      };
    };
}
