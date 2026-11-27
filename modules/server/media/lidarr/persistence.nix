{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.lidarr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.lidarr = {
        lidarrVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Lidarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.lidarr.enable) {
        services.k3s.manifests.lidarr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "lidarr-pv";
            };
            spec = {
              capacity.storage = config.media-server.lidarr.lidarrVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "lidarr";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "lidarr-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "lidarr-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = config.media-server.lidarr.lidarrVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "lidarr-pv";
            };
          }
        ];
      };
    };
}
