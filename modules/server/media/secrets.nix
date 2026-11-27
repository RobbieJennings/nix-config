{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.media-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.secrets.media-server = {
        enable = lib.mkEnableOption "jellyfin, transmission and servarr secrets";
      };

      config =
        lib.mkIf (config.media-server.enable && config.secrets.enable && config.secrets.media-server.enable)
          {
            sops.secrets = {
              "jellyfin/key" = { };
              "calibre/username" = { };
              "calibre/password" = { };
              "audiobookshelf/key" = { };
              "radarr/key" = { };
              "sonarr/key" = { };
              "lidarr/key" = { };
              "prowlarr/key" = { };
              "seerr/key" = { };
            };
          };
    };
}
