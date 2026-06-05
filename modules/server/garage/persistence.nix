{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.garage.enable {
        system.activationScripts.createGarageDirs = ''
          mkdir -p /storage/garage/meta /storage/garage/data
          chown 1000:1000 /storage/garage/meta /storage/garage/data
          chmod 775 /storage/garage/meta /storage/garage/data
        '';
        services.k3s.autoDeployCharts.garage = {
          values.persistence = {
            enabled = true;
            meta.storageClass = "";
            data.storageClass = "";
          };
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "PersistentVolume";
              metadata = {
                name = "meta-garage-0";
              };
              spec = {
                capacity.storage = "10Gi";
                accessModes = [ "ReadWriteOnce" ];
                persistentVolumeReclaimPolicy = "Retain";
                storageClassName = "";
                claimRef = {
                  namespace = "garage";
                  name = "meta-garage-0";
                };
                hostPath = {
                  path = "/storage/garage/meta";
                  type = "DirectoryOrCreate";
                };
              };
            }
            {
              apiVersion = "v1";
              kind = "PersistentVolume";
              metadata = {
                name = "data-garage-0";
              };
              spec = {
                capacity.storage = "100Gi";
                accessModes = [ "ReadWriteOnce" ];
                persistentVolumeReclaimPolicy = "Retain";
                storageClassName = "";
                claimRef = {
                  namespace = "garage";
                  name = "data-garage-0";
                };
                hostPath = {
                  path = "/storage/garage/data";
                  type = "DirectoryOrCreate";
                };
              };
            }
          ];
        };
      };
    };
}
