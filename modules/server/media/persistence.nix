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
      config = lib.mkIf config.media-server.enable {
        system.activationScripts.createMediaDirs = ''
          mkdir -p /media-server/media /media-server/downloads
          chown -R 1000:1000 /media-server/media /media-server/downloads
          chmod -R 775 /media-server/media /media-server/downloads
        '';
        services.k3s.manifests.media.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "media-pv";
            };
            spec = {
              capacity.storage = "25Gi";
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
              resources.requests.storage = "25Gi";
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "downloads-pv";
            };
            spec = {
              capacity.storage = "25Gi";
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
              resources.requests.storage = "25Gi";
            };
          }
        ];
      };
    };
}
