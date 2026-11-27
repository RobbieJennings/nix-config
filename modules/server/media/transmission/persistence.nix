{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.transmission-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.transmission = {
        transmissionVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Transmission";
        };
        transmissionWatchVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Transmission's watch directory";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.transmission.enable) {
        services.k3s.manifests.transmission.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "transmission-pv";
            };
            spec = {
              capacity.storage = config.media-server.transmission.transmissionVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "transmission";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "transmission-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "transmission-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = config.media-server.transmission.transmissionVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "transmission-pv";
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "transmission-watch-pv";
            };
            spec = {
              capacity.storage = config.media-server.transmission.transmissionWatchVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "transmission-watch";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "transmission-watch-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "transmission-watch-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = config.media-server.transmission.transmissionWatchVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "transmission-watch-pv";
            };
          }
        ];
      };
    };
}
