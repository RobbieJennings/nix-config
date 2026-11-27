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
      options.monitoring.loki = {
        lokiVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "10Gi";
          description = "Volume size for Loki";
        };
      };

      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s.autoDeployCharts.loki.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "loki-pv";
            };
            spec = {
              capacity.storage = config.monitoring.loki.lokiVolumeSize;
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
              resources.requests.storage = config.monitoring.loki.lokiVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "loki-pv";
            };
          }
        ];
      };
    };
}
