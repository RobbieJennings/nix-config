{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.radarr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.radarr.enable) {
        services.k3s.manifests.radarr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "radarr-pv";
            };
            spec = {
              capacity.storage = "5Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "radarr";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "radarr-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "radarr-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = "5Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "radarr-pv";
            };
          }
        ];
      };
    };
}
