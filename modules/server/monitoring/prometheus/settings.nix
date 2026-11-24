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
                    resources.requests.storage = "10Gi";
                    accessModes = [ "ReadWriteOnce" ];
                    volumeName = "prometheus-pv";
                  };
                };
              };
              thanos = {
                image = "${config._module.args.prometheusImages.thanosImage.imageName}:${config._module.args.prometheusImages.thanosImage.imageTag}";
                objectStorageConfig.existingSecret = {
                  name = "prometheus-thanos-secrets";
                  key = "thanos-config";
                };
              };
              retention = "24h";
              retentionPercentage = "60";
              resources = config.server.resources.profiles.appMedium;
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
                    resources.requests.storage = "10Gi";
                    accessModes = [ "ReadWriteOnce" ];
                    volumeName = "alertmanager-pv";
                  };
                };
              };
              resources = config.server.resources.profiles.appSmall;
            };
          };
          kube-state-metrics = {
            image = {
              registry = "registry.k8s.io";
              repository = "kube-state-metrics/kube-state-metrics";
              tag = config._module.args.prometheusImages.kubeStateMetricsImage.imageTag;
            };
            resources = config.server.resources.profiles.infraLarge;
          };
          prometheus-node-exporter = {
            image = {
              registry = "quay.io";
              repository = "prometheus/node-exporter";
              tag = config._module.args.prometheusImages.nodeExporterImage.imageTag;
            };
            resources = config.server.resources.profiles.infraLarge;
          };
          prometheusOperator = {
            image = {
              registry = "quay.io";
              repository = "prometheus-operator/prometheus-operator";
              tag = config._module.args.prometheusImages.prometheusOperatorImage.imageTag;
            };
            resources = config.server.resources.profiles.infraLarge;
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
