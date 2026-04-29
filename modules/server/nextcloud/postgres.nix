{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-postgres =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts.nextcloud = {
          values = {
            internalDatabase.enabled = false;
            externalDatabase = {
              enabled = true;
              type = "postgresql";
              host = "nextcloud-postgres-rw";
              existingSecret = {
                enabled = true;
                secretName = "nextcloud-secrets";
                usernameKey = "username";
                passwordKey = "password";
              };
            };
          };
          extraDeploy = [
            {
              apiVersion = "postgresql.cnpg.io/v1";
              kind = "Cluster";
              metadata = {
                namespace = "nextcloud";
                name = "nextcloud-postgres";
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
                    name = "nextcloud";
                    passwordSecret.name = "nextcloud-secrets";
                    login = true;
                  }
                ];
                bootstrap.initdb = {
                  database = "nextcloud";
                  owner = "nextcloud";
                  secret.name = "nextcloud-secrets";
                };
                resources = {
                  requests.cpu = "100m";
                  requests.memory = "256Mi";
                  limits.cpu = "500m";
                  limits.memory = "512Mi";
                };
              };
            }
          ];
        };
      };
    };
}
