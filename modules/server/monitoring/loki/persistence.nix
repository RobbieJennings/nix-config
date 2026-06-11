{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.loki-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s.autoDeployCharts.loki.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "loki-pv";
            };
            spec = {
              capacity.storage = "10Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "loki";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "monitoring";
                name = "loki-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "loki-pvc";
              namespace = "monitoring";
            };
            spec = {
              resources.requests.storage = "10Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "loki-pv";
            };
          }
        ];
      };
    };
}
