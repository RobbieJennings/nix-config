{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-postgres =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.immich.enable {
        services.k3s.autoDeployCharts.immich.extraDeploy = [
          {
            apiVersion = "postgresql.cnpg.io/v1";
            kind = "Cluster";
            metadata = {
              namespace = "immich";
              name = "immich-postgres";
            };
            spec = {
              instances = 1;
              imageCatalogRef = {
                apiGroup = "postgresql.cnpg.io";
                kind = "ClusterImageCatalog";
                name = "postgresql-global";
                major = 18;
              };
              storage.size = "8Gi";
              managed.roles = [
                {
                  name = "immich";
                  passwordSecret.name = "immich-secrets";
                  superuser = true;
                  login = true;
                }
              ];
              bootstrap.initdb = {
                database = "immich";
                owner = "immich";
                secret.name = "immich-secrets";
              };
              resources = {
                requests.cpu = "200m";
                requests.memory = "256Mi";
                limits.cpu = "1000m";
                limits.memory = "1Gi";
              };
            };
          }
        ];
      };
    };
}
