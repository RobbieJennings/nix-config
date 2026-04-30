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
                tag =
                  (lib.lists.findSingle (
                    x: x ? imageName && x.imageName == "quay.io/prometheus/prometheus"
                  ) null null config.services.k3s.images).imageTag;
              };
              storageSpec = {
                volumeClaimTemplate = {
                  spec = {
                    storageClassName = "longhorn";
                    resources.requests.storage = "10Gi";
                  };
                };
              };
              resources = {
                requests.cpu = "100m";
                requests.memory = "384Mi";
                limits.cpu = "500m";
                limits.memory = "768Mi";
              };
            };
            service.enabled = false;
          };
          alertmanager = {
            alertmanagerSpec = {
              replicas = 1;
              image = {
                registry = "quay.io";
                repository = "prometheus/alertmanager";
                tag =
                  (lib.lists.findSingle (
                    x: x ? imageName && x.imageName == "quay.io/prometheus/alertmanager"
                  ) null null config.services.k3s.images).imageTag;
              };
              storage = {
                volumeClaimTemplate = {
                  spec = {
                    storageClassName = "longhorn";
                    resources.requests.storage = "5Gi";
                  };
                };
              };
              resources = {
                requests.cpu = "50m";
                requests.memory = "128Mi";
                limits.cpu = "200m";
                limits.memory = "256Mi";
              };
            };
          };
          kube-state-metrics = {
            image = {
              registry = "registry.k8s.io";
              repository = "kube-state-metrics/kube-state-metrics";
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "registry.k8s.io/kube-state-metrics/kube-state-metrics"
                ) null null config.services.k3s.images).imageTag;
            };
            resources = {
              requests.cpu = "30m";
              requests.memory = "64Mi";
              limits.cpu = "150m";
              limits.memory = "128Mi";
            };
          };
          prometheus-node-exporter = {
            image = {
              registry = "quay.io";
              repository = "prometheus/node-exporter";
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "quay.io/prometheus/node-exporter"
                ) null null config.services.k3s.images).imageTag;
            };
            resources = {
              requests.cpu = "20m";
              requests.memory = "32Mi";
              limits.cpu = "100m";
              limits.memory = "64Mi";
            };
          };
          prometheusOperator = {
            image = {
              registry = "quay.io";
              repository = "prometheus-operator/prometheus-operator";
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "quay.io/prometheus-operator/prometheus-operator"
                ) null null config.services.k3s.images).imageTag;
            };
            resources = {
              requests.cpu = "50m";
              requests.memory = "128Mi";
              limits.cpu = "300m";
              limits.memory = "256Mi";
            };
            prometheusConfigReloader = {
              image = {
                registry = "quay.io";
                repository = "prometheus-operator/prometheus-config-reloader";
                tag =
                  (lib.lists.findSingle (
                    x: x ? imageName && x.imageName == "quay.io/prometheus-operator/prometheus-config-reloader"
                  ) null null config.services.k3s.images).imageTag;
              };
            };
          };
        };
      };
    };
}
