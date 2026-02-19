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
        secrets.media-server.enable = lib.mkEnableOption "jellyfin, transmission and servarr secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.media-server.enable {
          system.activationScripts.createMediaDirs = ''
            mkdir -p /media-server/media /media-server/downloads
            chown -R 1000:1000 /media-server/media /media-server/downloads
            chmod -R 775 /media-server/media /media-server/downloads
          '';
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
                kind = "PersistentVolume";
                metadata = {
                  name = "media-pv";
                };
                spec = {
                  capacity.storage = "100Gi";
                  accessModes = [ "ReadWriteMany" ];
                  persistentVolumeReclaimPolicy = "Retain";
                  storageClassName = "media";
                  hostPath = {
                    path = "/media-server/media";
                    type = "DirectoryOrCreate";
                  };
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
                  storageClassName = "media";
                  resources.requests.storage = "100Gi";
                };
              }
              {
                apiVersion = "v1";
                kind = "PersistentVolume";
                metadata = {
                  name = "downloads-pv";
                };
                spec = {
                  capacity.storage = "100Gi";
                  accessModes = [ "ReadWriteMany" ];
                  persistentVolumeReclaimPolicy = "Retain";
                  storageClassName = "downloads";
                  hostPath = {
                    path = "/media-server/downloads";
                    type = "DirectoryOrCreate";
                  };
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
                  storageClassName = "downloads";
                  resources.requests.storage = "100Gi";
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
        })
        (lib.mkIf
          (config.media-server.enable && config.secrets.enable && config.secrets.media-server.enable)
          {
            sops.secrets = {
              "jellyfin/key" = { };
              "radarr/key" = { };
              "sonarr/key" = { };
              "lidarr/key" = { };
              "prowlarr/key" = { };
            };
          }
        )
      ];
    };
}
