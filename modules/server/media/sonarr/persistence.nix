{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.sonarr = {
        sonarrVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "5Gi";
          description = "Volume size for Sonarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.sonarr.enable) {
        services.k3s.manifests.sonarr.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "sonarr-pv";
            };
            spec = {
              capacity.storage = config.media-server.sonarr.sonarrVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "sonarr";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "sonarr-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "sonarr-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = config.media-server.sonarr.sonarrVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "sonarr-pv";
            };
          }
        ];
      };
    };
}
