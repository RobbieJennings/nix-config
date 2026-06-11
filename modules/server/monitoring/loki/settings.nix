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
      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s.autoDeployCharts.loki.values = {
          deploymentMode = "SingleBinary";
          write.replicas = 0;
          read.replicas = 0;
          backend.replicas = 0;
          chunksCache.enabled = false;
          resultsCache.enabled = false;
          singleBinary = {
            image =
              let
                image = inputs.self.lib.findImageByName "grafana/loki" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
              };
            replicas = 1;
            persistence = {
              enabled = false;
              dataVolumeParameters.persistentVolumeClaim.claimName = "loki-pvc";
            };
            resources = config.server.resources.profiles.appSmall;
          };
          loki = {
            extraArgs = [ "-config.expand-env=true" ];
            extraEnvFrom = [
              {
                secretRef.name = "loki-secrets";
              }
            ];
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
                endpoint = "\${AWS_ENDPOINT}";
                accessKeyId = "\${AWS_ACCESS_KEY_ID}";
                secretAccessKey = "\${AWS_SECRET_ACCESS_KEY}";
                region = "garage";
                s3ForcePathStyle = true;
              };
            };
          };
          loki-canary = {
            image =
              let
                image = inputs.self.lib.findImageByName "grafana/loki-canary" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
              };
            resources = config.server.resources.profiles.appMini;
          };
        };
      };
    };
}
