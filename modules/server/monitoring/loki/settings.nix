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
            replicas = 1;
            service = {
              type = "LoadBalancer";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/loadBalancerIPs" = "192.168.1.210";
                "metallb.io/allow-shared-ip" = "monitoring";
              };
            };
          };
          loki = {
            image = {
              repository =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "grafana/loki"
                ) null null config.services.k3s.images).imageName;
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "grafana/loki"
                ) null null config.services.k3s.images).imageTag;
            };
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
            persistence = {
              enabled = true;
              storageClassName = "longhorn";
              size = "10Gi";
            };
            resources = config.server.resources.profiles.appSmall;
          };
          loki-canary = {
            image = {
              repository =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "grafana/loki-canary"
                ) null null config.services.k3s.images).imageName;
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "grafana/loki-canary"
                ) null null config.services.k3s.images).imageTag;
            };
            resources = config.server.resources.profiles.appMini;
          };
        };
      };
    };
}
