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
              thanos = {
                image = "quay.io/thanos/thanos:${
                  (lib.lists.findSingle (
                    x: x ? imageName && x.imageName == "quay.io/thanos/thanos"
                  ) null null config.services.k3s.images).imageTag
                }";
                objectStorageConfig.existingSecret = {
                  name = "prometheus-thanos-secrets";
                  key = "thanos-config";
                };
              };
              resources = config.server.resources.profiles.appSmall;
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
              resources = config.server.resources.profiles.appMini;
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
            resources = config.server.resources.profiles.infraSmall;
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
            resources = config.server.resources.profiles.infraMini;
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
            resources = config.server.resources.profiles.infraLarge;
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
