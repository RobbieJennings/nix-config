{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.loki-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.monitoring.loki = {
        lokiResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appSmall;
          description = "Resource profile for Loki";
        };
        lokiCanaryResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appMini;
          description = "Resource profile for Loki Canary";
        };
      };

      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s.autoDeployCharts.loki.values = {
          deploymentMode = "SingleBinary";
          write.replicas = 0;
          read.replicas = 0;
          backend.replicas = 0;
          chunksCache.enabled = false;
          resultsCache.enabled = false;
          defaults = {
            extraArgs = [ "-config.expand-env=true" ];
            extraEnvFrom = [
              {
                secretRef.name = "loki-secrets";
              }
            ];
          };
          singleBinary = {
            image = {
              repository = config._module.args.lokiImages.lokiImage.imageName;
              tag = config._module.args.lokiImages.lokiImage.imageTag;
            };
            replicas = 1;
            persistence = {
              enabled = false;
              dataVolumeParameters.persistentVolumeClaim.claimName = "loki-pvc";
            };
            resources = config.monitoring.loki.lokiResources;
          };
          loki = {
            auth_enabled = false;
            commonConfig.replication_factor = 1;
            schemaConfig = {
              configs = [
                {
                  from = "2024-01-01";
                  store = "tsdb";
                  object_store = "s3";
                  schema = "v13";
                  index = {
                    prefix = "index_";
                    period = "24h";
                  };
                }
              ];
            };
            limits_config = {
              reject_old_samples = true;
              reject_old_samples_max_age = "168h";
              max_cache_freshness_per_query = "10m";
              split_queries_by_interval = "15m";
              query_timeout = "300s";
              volume_enabled = true;
            };
            storage = {
              bucketNames = {
                chunks = "loki-chunks-bucket";
                ruler = "loki-ruler-bucket";
              };
              type = "s3";
              s3 = {
                accessKeyId = "\${AWS_ACCESS_KEY_ID}";
                secretAccessKey = "\${AWS_SECRET_ACCESS_KEY}";
                endpoint = "http://garage.garage.svc.cluster.local:3900";
                region = "garage";
                insecure = true;
                s3ForcePathStyle = true;
              };
            };
          };
          loki-canary = {
            image = {
              repository = config._module.args.lokiImages.lokiCanaryImage.imageName;
              tag = config._module.args.lokiImages.lokiCanaryImage.imageTag;
            };
            resources = config.monitoring.loki.lokiCanaryResources;
          };
        };
      };
    };
}
