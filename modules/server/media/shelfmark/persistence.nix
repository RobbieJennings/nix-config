{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.shelfmark-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.shelfmark.enable) {
        services.k3s.manifests.shelfmark.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "shelfmark-pv";
            };
            spec = {
              capacity.storage = "5Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "shelfmark";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "shelfmark-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "shelfmark-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = "5Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "shelfmark-pv";
            };
          }
        ];
      };
    };
}
