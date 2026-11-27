{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.seerr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.seerr = {
        seerrVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Seerr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.seerr.enable) {
        services.k3s.manifests.seerr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "seerr-pv";
            };
            spec = {
              capacity.storage = config.media-server.seerr.seerrVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "seerr";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "seerr-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "seerr-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = config.media-server.seerr.seerrVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "seerr-pv";
            };
          }
        ];
      };
    };
}
