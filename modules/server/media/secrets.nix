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
      config =
        lib.mkIf (config.media-server.enable && config.secrets.enable && config.secrets.media-server.enable)
          {
            sops.secrets = {
              "jellyfin/key" = { };
              "radarr/key" = { };
              "sonarr/key" = { };
              "lidarr/key" = { };
              "prowlarr/key" = { };
            };
          };
    };
}
