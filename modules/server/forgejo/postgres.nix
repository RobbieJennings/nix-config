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
      options = {
        forgejo.initdb.enable = lib.mkEnableOption "initialize fresh postgres database for Forgejo";
      };

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
              storage = {
                pvcTemplate = {
                  resources.requests.storage = "8Gi";
                  accessModes = [ "ReadWriteOnce" ];
                  volumeName = "forgejo-pg-pv";
                };
              };
              managed.roles = [
                {
                  name = "forgejo";
                  passwordSecret.name = "forgejo-secrets";
                  login = true;
                }
              ];
              bootstrap =
                if config.forgejo.initdb.enable then
                  {
                    initdb = {
                      database = "forgejo";
                      owner = "forgejo";
                      secret.name = "forgejo-secrets";
                    };
                  }
                else
                  {
                    recovery.source = "source";
                  };
              plugins = [
                {
                  name = "barman-cloud.cloudnative-pg.io";
                  isWALArchiver = true;
                  parameters = {
                    barmanObjectName = "garage-store";
                    serverName = "forgejo-postgres-backup-1"; # Must change before each restore
                  };
                }
              ];
              externalClusters = [
                {
                  name = "source";
                  plugin = {
                    name = "barman-cloud.cloudnative-pg.io";
                    parameters = {
                      barmanObjectName = "garage-store";
                      serverName = "forgejo-postgres-backup-0"; # Must match previous plugin server name
                    };
                  };
                }
              ];
              resources = config.server.resources.profiles.dbSmall;
            };
          }
          {
            apiVersion = "barmancloud.cnpg.io/v1";
            kind = "ObjectStore";
            metadata = {
              name = "garage-store";
              namespace = "forgejo";
            };
            spec = {
              configuration = {
                destinationPath = "s3://forgejo-postgres-bucket/";
                endpointURL = "http://garage.garage.svc.cluster.local:3900";
                s3Credentials = {
                  accessKeyId = {
                    name = "forgejo-secrets";
                    key = "AWS_ACCESS_KEY_ID";
                  };
                  secretAccessKey = {
                    name = "forgejo-secrets";
                    key = "AWS_SECRET_ACCESS_KEY";
                  };
                  region = {
                    name = "forgejo-secrets";
                    key = "AWS_REGION";
                  };
                };
                wal.compression = "gzip";
              };
              retentionPolicy = "30d";
              instanceSidecarConfiguration.resources = config.server.resources.profiles.infraLarge;
            };
          }
          {
            apiVersion = "postgresql.cnpg.io/v1";
            kind = "ScheduledBackup";
            metadata = {
              name = "forgejo-postgres-backup";
              namespace = "forgejo";
            };
            spec = {
              cluster.name = "forgejo-postgres";
              method = "plugin";
              pluginConfiguration.name = "barman-cloud.cloudnative-pg.io";
              backupOwnerReference = "self";
              schedule = "0 0 0 * * *";
            };
          }
          {
            apiVersion = "monitoring.coreos.com/v1";
            kind = "PodMonitor";
            metadata = {
              name = "forgejo-postgres-prometheus-podmonitor";
              namespace = "monitoring";
              labels.release = "prometheus";
            };
            spec = {
              selector.matchLabels = {
                "cnpg.io/cluster" = "forgejo-postgres";
              };
              namespaceSelector.matchNames = [ "forgejo" ];
              podMetricsEndpoints = [
                { port = "metrics"; }
              ];
            };
          }
        ];
      };
    };
}
