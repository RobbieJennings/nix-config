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
      options = {
        nextcloud.initdb.enable = lib.mkEnableOption "initialize fresh postgres database for Nextcloud";
      };

      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts.nextcloud.extraDeploy = [
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
              storage = {
                pvcTemplate = {
                  resources.requests.storage = "8Gi";
                  accessModes = [ "ReadWriteOnce" ];
                  volumeName = "nextcloud-pg-pv";
                };
              };
              managed.roles = [
                {
                  name = "nextcloud";
                  passwordSecret.name = "nextcloud-secrets";
                  login = true;
                }
              ];
              bootstrap =
                if config.nextcloud.initdb.enable then
                  {
                    initdb = {
                      database = "nextcloud";
                      owner = "nextcloud";
                      secret.name = "nextcloud-secrets";
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
                    serverName = "nextcloud-postgres-backup-1"; # Must change before each restore
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
                      serverName = "nextcloud-postgres-backup-0"; # Must match previous plugin server name
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
              namespace = "nextcloud";
            };
            spec = {
              configuration = {
                destinationPath = "s3://nextcloud-postgres-bucket/";
                endpointURL = "http://garage.garage.svc.cluster.local:3900";
                s3Credentials = {
                  accessKeyId = {
                    name = "nextcloud-secrets";
                    key = "AWS_ACCESS_KEY_ID";
                  };
                  secretAccessKey = {
                    name = "nextcloud-secrets";
                    key = "AWS_SECRET_ACCESS_KEY";
                  };
                  region = {
                    name = "nextcloud-secrets";
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
              name = "nextcloud-postgres-backup";
              namespace = "nextcloud";
            };
            spec = {
              cluster.name = "nextcloud-postgres";
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
              name = "nextcloud-postgres-prometheus-podmonitor";
              namespace = "monitoring";
              labels.release = "prometheus";
            };
            spec = {
              selector.matchLabels = {
                "cnpg.io/cluster" = "nextcloud-postgres";
              };
              namespaceSelector.matchNames = [ "nextcloud" ];
              podMetricsEndpoints = [
                { port = "metrics"; }
              ];
            };
          }
        ];
      };
    };
}
