{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.audiobookshelf-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.audiobookshelf.enable) {
        services.k3s.manifests.audiobookshelf.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "audiobookshelf-pv";
            };
            spec = {
              capacity.storage = "5Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "audiobookshelf";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "audiobookshelf-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "audiobookshelf-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = "5Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "audiobookshelf-pv";
            };
          }
        ];
      };
    };
}
