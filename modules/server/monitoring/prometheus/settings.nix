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
              image =
                let
                  image = inputs.self.lib.findImageByName "quay.io/prometheus/prometheus" config.services.k3s.images;
                in
                {
                  registry = "quay.io";
                  repository = "prometheus/prometheus";
                  tag = image.imageTag;
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
                image =
                  let
                    image = inputs.self.lib.findImageByName "quay.io/thanos/thanos" config.services.k3s.images;
                  in
                  "${image.imageName}:${image.imageTag}";
                objectStorageConfig.existingSecret = {
                  name = "prometheus-thanos-secrets";
                  key = "thanos-config";
                };
              };
              resources = config.server.resources.profiles.appMedium;
            };
            service.enabled = false;
            thanosService.enabled = true;
            thanosServiceMonitor.enabled = true;
          };
          alertmanager = {
            alertmanagerSpec = {
              replicas = 1;
              image =
                let
                  image = inputs.self.lib.findImageByName "quay.io/prometheus/alertmanager" config.services.k3s.images;
                in
                {
                  registry = "quay.io";
                  repository = "prometheus/alertmanager";
                  tag = image.imageTag;
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
            image =
              let
                image = inputs.self.lib.findImageByName "registry.k8s.io/kube-state-metrics/kube-state-metrics" config.services.k3s.images;
              in
              {
                registry = "registry.k8s.io";
                repository = "kube-state-metrics/kube-state-metrics";
                tag = image.imageTag;
              };
            resources = config.server.resources.profiles.infraLarge;
          };
          prometheus-node-exporter = {
            image =
              let
                image = inputs.self.lib.findImageByName "quay.io/prometheus/node-exporter" config.services.k3s.images;
              in
              {
                registry = "quay.io";
                repository = "prometheus/node-exporter";
                tag = image.imageTag;
              };
            resources = config.server.resources.profiles.infraLarge;
          };
          prometheusOperator = {
            image =
              let
                image = inputs.self.lib.findImageByName "quay.io/prometheus-operator/prometheus-operator" config.services.k3s.images;
              in
              {
                registry = "quay.io";
                repository = "prometheus-operator/prometheus-operator";
                tag = image.imageTag;
              };
            resources = config.server.resources.profiles.infraLarge;
            prometheusConfigReloader = {
              image =
                let
                  image = inputs.self.lib.findImageByName "quay.io/prometheus-operator/prometheus-config-reloader" config.services.k3s.images;
                in
                {
                  registry = "quay.io";
                  repository = "prometheus-operator/prometheus-config-reloader";
                  tag = image.imageTag;
                };
            };
          };
        };
      };
    };
}
