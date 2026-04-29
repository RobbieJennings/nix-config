{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-postgres =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s.autoDeployCharts.forgejo.extraDeploy = [
          {
            apiVersion = "postgresql.cnpg.io/v1";
            kind = "Cluster";
            metadata = {
              namespace = "forgejo";
              name = "forgejo-postgres";
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
                  name = "forgejo";
                  passwordSecret.name = "forgejo-secrets";
                  login = true;
                }
              ];
              bootstrap.initdb = {
                database = "forgejo";
                owner = "forgejo";
                secret.name = "forgejo-secrets";
              };
              resources = {
                requests.cpu = "50m";
                requests.memory = "256Mi";
                limits.cpu = "300m";
                limits.memory = "512Mi";
              };
            };
          }
        ];
      };
    };
}
