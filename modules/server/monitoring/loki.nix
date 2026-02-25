{
  inputs,
  ...
}:
{
  flake.modules.nixos.loki =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "loki";
        repo = "https://grafana.github.io/helm-charts";
        version = "6.53.0";
        hash = "sha256-Op38u8XMpiwakIeT6a4+/Uzn78mSSCM6co3HCrrZSM4=";
      };
      lokiImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/loki";
        imageDigest = "sha256:146a6add37403d7f74aa17f52a849de9babf24f92890613cacf346e12a969efc";
        sha256 = "sha256-Wk3gOMI3ev2iminSM/UO3Dj8Do2TzMbT2VdX/FJ+1Gg=";
        finalImageTag = "3.6.5";
        arch = "amd64";
      };
      lokiCanaryImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/loki-canary";
        imageDigest = "sha256:76ae2f73a7dbc71a66bb774315c1c0cb58176536127d9ac5364ce7e4405211cd";
        sha256 = "sha256-jbrnGJ5CKUPHSkpfXBFbLh6kYkwQmEZj/wvk/+KyKMI=";
        finalImageTag = "3.6.5";
        arch = "amd64";
      };
    in
    {
      options.monitoring.loki.enable = lib.mkEnableOption "loki service on k3s";

      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s = {
          images = [
            lokiImage
            lokiCanaryImage
          ];
          autoDeployCharts.loki = chart // {
            targetNamespace = "monitoring";
            createNamespace = true;
            values = {
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
                  repository = lokiImage.imageName;
                  tag = lokiImage.imageTag;
                };
                auth_enabled = false;
                commonConfig.replication_factor = 1;
                schemaConfig = {
                  configs = [
                    {
                      from = "2024-01-01";
                      store = "tsdb";
                      object_store = "filesystem";
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
                  type = "filesystem";
                  filesystem = {
                    chunks_directory = "/var/loki/chunks";
                    rules_directory = "/var/loki/rules";
                  };
                };
                persistence = {
                  enabled = true;
                  storageClassName = "longhorn";
                  size = "10Gi";
                };
                resources = {
                  requests = {
                    cpu = "100m";
                    memory = "256Mi";
                  };
                  limits = {
                    cpu = "500m";
                    memory = "512Mi";
                  };
                };
              };
              loki-canary = {
                image = {
                  repository = lokiCanaryImage.imageName;
                  tag = lokiCanaryImage.imageTag;
                };
                resources = {
                  requests = {
                    cpu = "10m";
                    memory = "32Mi";
                  };
                  limits = {
                    cpu = "100m";
                    memory = "128Mi";
                  };
                };
              };
            };
          };
        };
      };
    };
}
