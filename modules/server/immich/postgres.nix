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
      options = {
        immich.initdb.enable = lib.mkEnableOption "initialize fresh postgres database for Immich";
      };

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
              storage = {
                pvcTemplate = {
                  resources.requests.storage = "8Gi";
                  accessModes = [ "ReadWriteOnce" ];
                  volumeName = "immich-pg-pv";
                };
              };
              managed.roles = [
                {
                  name = "immich";
                  passwordSecret.name = "immich-secrets";
                  superuser = true;
                  login = true;
                }
              ];
              bootstrap =
                if config.immich.initdb.enable then
                  {
                    initdb = {
                      database = "immich";
                      owner = "immich";
                      secret.name = "immich-secrets";
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
                    serverName = "immich-postgres-backup-1"; # Must change before each restore
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
                      serverName = "immich-postgres-backup-0"; # Must match previous plugin server name
                    };
                  };
                }
              ];
              resources = config.server.resources.profiles.dbMedium;
            };
          }
          {
            apiVersion = "barmancloud.cnpg.io/v1";
            kind = "ObjectStore";
            metadata = {
              name = "garage-store";
              namespace = "immich";
            };
            spec = {
              configuration = {
                destinationPath = "s3://immich-postgres-bucket/";
                endpointURL = "http://garage.garage.svc.cluster.local:3900";
                s3Credentials = {
                  accessKeyId = {
                    name = "immich-secrets";
                    key = "AWS_ACCESS_KEY_ID";
                  };
                  secretAccessKey = {
                    name = "immich-secrets";
                    key = "AWS_SECRET_ACCESS_KEY";
                  };
                  region = {
                    name = "immich-secrets";
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
              name = "immich-postgres-backup";
              namespace = "immich";
            };
            spec = {
              cluster.name = "immich-postgres";
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
              name = "immich-postgres-prometheus-podmonitor";
              namespace = "monitoring";
              labels.release = "prometheus";
            };
            spec = {
              selector.matchLabels = {
                "cnpg.io/cluster" = "immich-postgres";
              };
              namespaceSelector.matchNames = [ "immich" ];
              podMetricsEndpoints = [
                { port = "metrics"; }
              ];
            };
          }
        ];
      };
    };
}
