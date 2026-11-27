{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.nextcloud = {
        nextcloudVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "10Gi";
          description = "Volume size for Nextcloud";
        };
        nextcloudDataVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "10Gi";
          description = "Volume size for Nextcloud's Collabora instance";
        };
        postgresVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "8Gi";
          description = "Volume size for Nextcloud's Postgres Database";
        };
      };

      config = lib.mkIf config.nextcloud.enable {
        system.activationScripts.createNextcloudDirs = ''
          mkdir -p /storage/nextcloud
          chown 1000:1000 /storage/nextcloud
          chmod 775 /storage/nextcloud
        '';
        services.k3s.autoDeployCharts.nextcloud.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "nextcloud-pv";
            };
            spec = {
              capacity.storage = config.nextcloud.nextcloudVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "nextcloud";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "nextcloud";
                name = "nextcloud-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "nextcloud-pvc";
              namespace = "nextcloud";
            };
            spec = {
              resources.requests.storage = config.nextcloud.nextcloudVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              volumeName = "nextcloud-pv";
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "nextcloud-data-pv";
            };
            spec = {
              capacity.storage = config.nextcloud.nextcloudDataVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              hostPath = {
                path = "/storage/nextcloud";
                type = "DirectoryOrCreate";
              };
              claimRef = {
                namespace = "nextcloud";
                name = "nextcloud-data-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "nextcloud-data-pvc";
              namespace = "nextcloud";
            };
            spec = {
              volumeName = "nextcloud-data-pv";
              resources.requests.storage = "25Gi";
              accessModes = [ "ReadWriteOnce" ];
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "nextcloud-pg-pv";
            };
            spec = {
              capacity.storage = config.nextcloud.postgresVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "nextcloud-pg";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "nextcloud";
                name = "nextcloud-postgres-1";
              };
            };
          }
        ];
      };
    };
}
