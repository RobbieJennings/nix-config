{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prowlarr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.prowlarr = {
        prowlarrVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Prowlarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.prowlarr.enable) {
        services.k3s.manifests.prowlarr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "prowlarr-pv";
            };
            spec = {
              capacity.storage = config.media-server.prowlarr.prowlarrVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "prowlarr";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "prowlarr-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "prowlarr-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = config.media-server.prowlarr.prowlarrVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "prowlarr-pv";
            };
          }
        ];
      };
    };
}
