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
      config = lib.mkIf config.nextcloud.enable {
        system.activationScripts.createNextcloudDirs = ''
          mkdir -p /storage/nextcloud
          chown 1000:1000 /storage/nextcloud
          chmod 775 /storage/nextcloud
        '';
        services.k3s.autoDeployCharts.nextcloud = {
          values = {
            persistence = {
              enabled = true;
              size = "8Gi";
              storageClass = "longhorn";
              nextcloudData = {
                enabled = true;
                existingClaim = "nextcloud-data-pvc";
              };
            };
          };
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "PersistentVolume";
              metadata = {
                name = "nextcloud-data-pv";
              };
              spec = {
                capacity.storage = "100Gi";
                accessModes = [ "ReadWriteOnce" ];
                persistentVolumeReclaimPolicy = "Retain";
                claimRef = {
                  namespace = "nextcloud";
                  name = "nextcloud-data-pvc";
                };
                hostPath = {
                  path = "/storage/nextcloud";
                  type = "DirectoryOrCreate";
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
                storageClassName = "";
              };
            }
          ];
        };
      };
    };
}
