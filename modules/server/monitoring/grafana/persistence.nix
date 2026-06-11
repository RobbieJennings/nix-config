{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.autoDeployCharts.grafana.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "grafana-pv";
            };
            spec = {
              capacity.storage = "10Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "grafana";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "monitoring";
                name = "grafana-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "grafana-pvc";
              namespace = "monitoring";
            };
            spec = {
              resources.requests.storage = "10Gi";
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "grafana-pv";
            };
          }
        ];
      };
    };
}
