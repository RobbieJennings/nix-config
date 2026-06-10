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
              capacity.storage = "100Gi";
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
              capacity.storage = "100Gi";
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
