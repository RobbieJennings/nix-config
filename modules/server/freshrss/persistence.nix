{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.freshrss.enable {
        services.k3s.manifests.freshrss.content = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "freshrss-pv";
            };
            spec = {
              capacity.storage = "10Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "freshrss";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "freshrss";
                name = "freshrss-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "freshrss-pvc";
              namespace = "freshrss";
            };
            spec = {
              resources.requests.storage = "10Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "freshrss-pv";
            };
          }
        ];
      };
    };
}
