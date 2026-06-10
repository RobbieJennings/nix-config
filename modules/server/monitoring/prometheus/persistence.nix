{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s.autoDeployCharts.prometheus = {
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "PersistentVolume";
              metadata = {
                name = "prometheus-pv";
              };
              spec = {
                capacity.storage = "10Gi";
                volumeMode = "Filesystem";
                accessModes = [ "ReadWriteOnce" ];
                persistentVolumeReclaimPolicy = "Retain";
                csi = {
                  driver = "driver.longhorn.io";
                  volumeHandle = "prometheus";
                  fsType = "ext4";
                };
                claimRef = {
                  namespace = "monitoring";
                  name = "prometheus-prometheus-kube-prometheus-prometheus-db-prometheus-prometheus-kube-prometheus-prometheus-0";
                };
              };
            }
            {
              apiVersion = "v1";
              kind = "PersistentVolume";
              metadata = {
                name = "alertmanager-pv";
              };
              spec = {
                capacity.storage = "10Gi";
                volumeMode = "Filesystem";
                accessModes = [ "ReadWriteOnce" ];
                persistentVolumeReclaimPolicy = "Retain";
                csi = {
                  driver = "driver.longhorn.io";
                  volumeHandle = "alertmanager";
                  fsType = "ext4";
                };
                claimRef = {
                  namespace = "monitoring";
                  name = "alertmanager-prometheus-kube-prometheus-alertmanager-db-alertmanager-prometheus-kube-prometheus-alertmanager-0";
                };
              };
            }
          ];
        };
      };
    };
}
