{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.forgejo = {
        forgejoVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "100Gi";
          description = "Volume size for Forgejo";
        };
        postgresVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "8Gi";
          description = "Volume size for Forgejo's Postgres Database";
        };
      };

      config = lib.mkIf config.forgejo.enable {
        system.activationScripts.createForgejoDirs = ''
          mkdir -p /storage/forgejo
          chown 1000:1000 /storage/forgejo
          chmod 775 /storage/forgejo
        '';
        services.k3s.autoDeployCharts.forgejo.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "forgejo-pv";
            };
            spec = {
              capacity.storage = config.forgejo.forgejoVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              hostPath = {
                path = "/storage/forgejo";
                type = "DirectoryOrCreate";
              };
              claimRef = {
                namespace = "forgejo";
                name = "forgejo-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "forgejo-pvc";
              namespace = "forgejo";
            };
            spec = {
              volumeName = "forgejo-pv";
              resources.requests.storage = "25Gi";
              accessModes = [ "ReadWriteOnce" ];
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "forgejo-pg-pv";
            };
            spec = {
              capacity.storage = config.forgejo.postgresVolumeSize;
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "forgejo-pg";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "forgejo";
                name = "forgejo-postgres-1";
              };
            };
          }
        ];
      };
    };
}
