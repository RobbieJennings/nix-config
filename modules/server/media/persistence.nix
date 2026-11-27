{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.media-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server = {
        mediaVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "100Gi";
          description = "Volume size for media files";
        };
        downloadVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "100Gi";
          description = "Volume size for download files";
        };
      };

      config = lib.mkIf config.media-server.enable {
        system.activationScripts.createMediaDirs = ''
          mkdir -p /storage/media /storage/downloads
          chown 1000:1000 /storage/media /storage/downloads
          chmod 775 /storage/media /storage/downloads
        '';
        services.k3s.manifests.media.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "media-pv";
            };
            spec = {
              capacity.storage = config.media-server.mediaVolumeSize;
              accessModes = [ "ReadWriteMany" ];
              persistentVolumeReclaimPolicy = "Retain";
              hostPath = {
                path = "/storage/media";
                type = "DirectoryOrCreate";
              };
              claimRef = {
                namespace = "media";
                name = "media-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "media-pvc";
              namespace = "media";
            };
            spec = {
              volumeName = "media-pv";
              resources.requests.storage = "25Gi";
              accessModes = [ "ReadWriteMany" ];
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "downloads-pv";
            };
            spec = {
              capacity.storage = config.media-server.downloadVolumeSize;
              accessModes = [ "ReadWriteMany" ];
              persistentVolumeReclaimPolicy = "Retain";
              hostPath = {
                path = "/storage/downloads";
                type = "DirectoryOrCreate";
              };
              claimRef = {
                namespace = "media";
                name = "downloads-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "downloads-pvc";
              namespace = "media";
            };
            spec = {
              volumeName = "downloads-pv";
              resources.requests.storage = "25Gi";
              accessModes = [ "ReadWriteMany" ];
            };
          }
        ];
      };
    };
}
