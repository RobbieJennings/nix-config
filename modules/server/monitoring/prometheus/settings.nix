{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.monitoring.prometheus = {
        prometheusResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appMedium;
          description = "Resource profile for Prometheus";
        };
        thanosResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraLarge;
          description = "Resource profile for Prometheus's Thanos sidecar";
        };
        alertManagerResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appSmall;
          description = "Resource profile for Alert Manager";
        };
        kubeMetricsResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraLarge;
          description = "Resource profile for Prometheus's kube-state-metrics agent";
        };
        nodeExporterResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraLarge;
          description = "Resource profile for Prometheus's node exporter";
        };
        operatorResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraLarge;
          description = "Resource profile for Prometheus's operator";
        };
      };

      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s.autoDeployCharts.prometheus.values = {
          grafana.enabled = false;
          prometheus = {
            prometheusSpec = {
              replicas = 1;
              image = {
                registry = "quay.io";
                repository = "prometheus/prometheus";
                tag = config._module.args.prometheusImages.prometheusImage.imageTag;
              };
              storageSpec = {
                volumeClaimTemplate = {
                  spec = {
                    resources.requests.storage = config.monitoring.prometheus.prometheusVolumeSize;
                    accessModes = [ "ReadWriteOnce" ];
                    volumeName = "prometheus-pv";
                  };
                };
              };
              thanos = {
                image = "${config._module.args.prometheusImages.thanosImage.imageName}:${config._module.args.prometheusImages.thanosImage.imageTag}";
                resources = config.monitoring.prometheus.thanosResources;
                objectStorageConfig.existingSecret = {
                  name = "prometheus-thanos-secrets";
                  key = "thanos-config";
                };
              };
              retention = "24h";
              retentionPercentage = "60";
              resources = config.monitoring.prometheus.prometheusResources;
            };
            service.enabled = false;
            thanosService.enabled = true;
            thanosServiceMonitor.enabled = true;
          };
          alertmanager = {
            alertmanagerSpec = {
              replicas = 1;
              image = {
                registry = "quay.io";
                repository = "prometheus/alertmanager";
                tag = config._module.args.prometheusImages.alertmanagerImage.imageTag;
              };
              storage = {
                volumeClaimTemplate = {
                  spec = {
                    resources.requests.storage = config.monitoring.prometheus.alertmanagerVolumeSize;
                    accessModes = [ "ReadWriteOnce" ];
                    volumeName = "alertmanager-pv";
                  };
                };
              };
              resources = config.monitoring.prometheus.alertManagerResources;
            };
          };
          kube-state-metrics = {
            image = {
              registry = "registry.k8s.io";
              repository = "kube-state-metrics/kube-state-metrics";
              tag = config._module.args.prometheusImages.kubeStateMetricsImage.imageTag;
            };
            resources = config.monitoring.prometheus.kubeMetricsResources;
          };
          prometheus-node-exporter = {
            image = {
              registry = "quay.io";
              repository = "prometheus/node-exporter";
              tag = config._module.args.prometheusImages.nodeExporterImage.imageTag;
            };
            resources = config.monitoring.prometheus.nodeExporterResources;
          };
          prometheusOperator = {
            image = {
              registry = "quay.io";
              repository = "prometheus-operator/prometheus-operator";
              tag = config._module.args.prometheusImages.prometheusOperatorImage.imageTag;
            };
            resources = config.monitoring.prometheus.operatorResources;
            prometheusConfigReloader = {
              image = {
                registry = "quay.io";
                repository = "prometheus-operator/prometheus-config-reloader";
                tag = config._module.args.prometheusImages.prometheusConfigReloaderImage.imageTag;
              };
            };
          };
        };
      };
    };
}
