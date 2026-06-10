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
      config = lib.mkIf config.forgejo.enable {
        system.activationScripts.createForgejoDirs = ''
          mkdir -p /storage/forgejo
          chown 1000:1000 /storage/forgejo
          chmod 775 /storage/forgejo
        '';
        services.k3s.autoDeployCharts.forgejo = {
          values.persistence = {
            enabled = true;
            create = false;
            claimName = "forgejo-pvc";
          };
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "PersistentVolume";
              metadata = {
                name = "forgejo-pv";
              };
              spec = {
                capacity.storage = "100Gi";
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
                capacity.storage = "8Gi";
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
    };
}
