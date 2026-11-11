{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.calibre-web-automated-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.calibre-web-automated.enable) {
        services.k3s.manifests.calibre-web-automated.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "calibre-web-automated-pv";
            };
            spec = {
              capacity.storage = "5Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "calibre-web-automated";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "media";
                name = "calibre-web-automated-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "calibre-web-automated-pvc";
              namespace = "media";
            };
            spec = {
              resources.requests.storage = "5Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "calibre-web-automated-pv";
            };
          }
        ];
      };
    };
}
