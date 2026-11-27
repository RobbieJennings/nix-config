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
      options.garage = {
        metaVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "10Gi";
          description = "Volume size for Garage metadata";
        };
        dataVolumeSize = lib.mkOption {
          type = lib.types.str;
          default = "100Gi";
          description = "Volume size for Garage data";
        };
      };

      config = lib.mkIf config.garage.enable {
        system.activationScripts.createGarageDirs = ''
          mkdir -p /storage/garage/meta /storage/garage/data
          chown 1000:1000 /storage/garage/meta /storage/garage/data
          chmod 775 /storage/garage/meta /storage/garage/data
        '';
        services.k3s.autoDeployCharts.garage.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "PersistentVolume";
            metadata = {
              name = "meta-garage-0";
            };
            spec = {
              capacity.storage = config.garage.metaVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              hostPath = {
                path = "/storage/garage/meta";
                type = "DirectoryOrCreate";
              };
              claimRef = {
                namespace = "garage";
                name = "meta-garage-0";
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
              capacity.storage = config.garage.dataVolumeSize;
              accessModes = [ "ReadWriteOnce" ];
              persistentVolumeReclaimPolicy = "Retain";
              hostPath = {
                path = "/storage/garage/data";
                type = "DirectoryOrCreate";
              };
              claimRef = {
                namespace = "garage";
                name = "data-garage-0";
              };
            };
          }
        ];
      };
    };
}
