{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.immich.enable {
        system.activationScripts.createImmichDirs = ''
          mkdir -p /storage/immich
          chown 1000:1000 /storage/immich
          chmod 775 /storage/immich
        '';
        services.k3s.autoDeployCharts.immich.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "immich-pv";
            };
            spec = {
              capacity.storage = "100Gi";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              hostPath = {
                path = "/storage/immich";
                type = "DirectoryOrCreate";
              };
              claimRef = {
                namespace = "immich";
                name = "immich-pvc";
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolumeClaim";
            metadata = {
              name = "immich-pvc";
              namespace = "immich";
            };
            spec = {
              volumeName = "immich-pv";
              resources.requests.storage = "25Gi";
              accessModes = [ "ReadWriteOnce" ];
            };
          }
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "immich-pg-pv";
            };
            spec = {
              capacity.storage = "8Gi";
              volumeMode = "Filesystem";
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              csi = {
                driver = "driver.longhorn.io";
                volumeHandle = "immich-pg";
                fsType = "ext4";
              };
              claimRef = {
                namespace = "immich";
                name = "immich-postgres-1";
              };
            };
          }
        ];
      };
    };
}
