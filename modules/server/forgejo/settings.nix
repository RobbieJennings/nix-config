{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s.autoDeployCharts.forgejo.values = {
          gitea = {
            admin.existingSecret = "forgejo-admin-secrets";
            config = {
              server = {
                DOMAIN = "forgejo.forgejo.homelab";
                ROOT_URL = "http://forgejo.forgejo.homelab";
              };
              database = {
                DB_TYPE = "postgres";
                HOST = "forgejo-postgres-rw:5432";
                NAME = "forgejo";
                USER = "forgejo";
              };
              cache.ADAPTER = "redis";
              session.PROVIDER = "redis";
              queue.TYPE = "redis";
              indexer = {
                ISSUE_INDEXER_TYPE = "bleve";
                REPO_INDEXER_ENABLED = true;
              };
            };
            additionalConfigFromEnvs = [
              {
                name = "FORGEJO__DATABASE__PASSWD";
                valueFrom.secretKeyRef = {
                  name = "forgejo-secrets";
                  key = "password";
                };
              }
              {
                name = "FORGEJO__CACHE__HOST";
                valueFrom.secretKeyRef = {
                  name = "forgejo-secrets";
                  key = "valkey-url";
                };
              }
              {
                name = "FORGEJO__SESSION__PROVIDER_CONFIG";
                valueFrom.secretKeyRef = {
                  name = "forgejo-secrets";
                  key = "valkey-url";
                };
              }
              {
                name = "FORGEJO__QUEUE__CONN_STR";
                valueFrom.secretKeyRef = {
                  name = "forgejo-secrets";
                  key = "valkey-url";
                };
              }
            ];
          };
          resources = {
            requests.cpu = "50m";
            requests.memory = "256Mi";
            limits.cpu = "300m";
            limits.memory = "512Mi";
          };
        };
      };
    };
}
