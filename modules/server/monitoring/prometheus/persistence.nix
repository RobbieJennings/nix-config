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
      options.monitoring.prometheus = {
        prometheusVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "10Gi";
          description = "Volume size for Prometheus";
        };
        alertmanagerVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "10Gi";
          description = "Volume size for Alert Manager";
        };
        thanosCompactorVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "10Gi";
          description = "Volume size for Prometheus's Thanos compactor";
        };
      };

      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s.autoDeployCharts.prometheus.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "prometheus-pv";
            };
            spec = {
              capacity.storage = config.monitoring.prometheus.prometheusVolumeSize;
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
              capacity.storage = config.monitoring.prometheus.alertmanagerVolumeSize;
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
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "prometheus-thanos-compactor-pv";
            };
            spec = {
              capacity.storage = config.monitoring.prometheus.thanosCompactorVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "prometheus-thanos-compactor";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "monitoring";
                name = "prometheus-thanos-compactor-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "prometheus-thanos-compactor-pvc";
              namespace = "monitoring";
            };
            spec = {
              resources.requests.storage = config.monitoring.prometheus.thanosCompactorVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "prometheus-thanos-compactor-pv";
            };
          }
        ];
      };
    };
}
