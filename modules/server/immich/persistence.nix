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
        services.k3s.autoDeployCharts.immich = {
          values.immich.persistence.library.existingClaim = "immich-pvc";
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "PersistentVolumeClaim";
              metadata = {
                name = "immich-pvc";
                namespace = "immich";
              };
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                resources = {
                  requests = {
                    storage = "25Gi";
                  };
                };
              };
            }
          ];
        };
      };
    };
}
