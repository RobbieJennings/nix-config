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
        inputs.self.modules.nixos.jellyfin
        inputs.self.modules.nixos.transmission
        inputs.self.modules.nixos.flaresolverr
        inputs.self.modules.nixos.prowlarr
        inputs.self.modules.nixos.radarr
        inputs.self.modules.nixos.sonarr
        inputs.self.modules.nixos.lidarr
      ];

      options = {
        media-server.enable = lib.mkEnableOption "jellyfin, transmission and servarr services on k3s";
      };

      config = lib.mkIf config.media-server.enable {
        services.k3s = {
          manifests.media.content = [
            {
              apiVersion = "v1";
              kind = "Namespace";
              metadata = {
                name = "media";
              };
            }
            {
              apiVersion = "v1";
              kind = "PersistentVolumeClaim";
              metadata = {
                name = "media";
                namespace = "media";
              };
              spec = {
                accessModes = [ "ReadWriteMany" ];
                storageClassName = "longhorn";
                resources.requests.storage = "25Gi";
              };
            }
            {
              apiVersion = "v1";
              kind = "PersistentVolumeClaim";
              metadata = {
                name = "downloads";
                namespace = "media";
              };
              spec = {
                accessModes = [ "ReadWriteMany" ];
                storageClassName = "longhorn";
                resources.requests.storage = "25Gi";
              };
            }
          ];
        };

        media-server = {
          jellyfin.enable = lib.mkDefault true;
          transmission.enable = lib.mkDefault true;
          flaresolverr.enable = lib.mkDefault true;
          prowlarr.enable = lib.mkDefault true;
          radarr.enable = lib.mkDefault true;
          sonarr.enable = lib.mkDefault true;
          lidarr.enable = lib.mkDefault true;
        };
      };
    };
}
