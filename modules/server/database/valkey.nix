# Factory module for use when valkey-cluster is not supported
# as operator cannot be used to deploy standalone valkey instances
{
  self,
  inputs,
  ...
}:
{
  config.flake.factory.valkey =
    {
      namespace,
      values,
    }:
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      chart = {
        name = "valkey";
        repo = "https://valkey.io/valkey-helm";
        version = "0.10.0";
        hash = "sha256-ZJfnhOG3B8MD41j2+db4L5MWGPSx5aeusJRt9RoIH+Y=";
      };
    in
    {
      config = {
        services.k3s = {
          autoDeployCharts = {
            "${namespace}-valkey" = chart // {
              targetNamespace = namespace;
              createNamespace = true;
              values = values // {
                image =
                  let
                    image = inputs.self.lib.findImageByName "valkey/valkey" config.services.k3s.images;
                  in
                  values.image or {
                    repository = image.imageName;
                    tag = image.imageTag;
                  };
                resources = values.resources or config.server.resources.profiles.cache;
                metrics =
                  values.metrics or {
                    enabled = true;
                    exporter.image =
                      let
                        image = inputs.self.lib.findImageByName "oliver006/redis_exporter" config.services.k3s.images;
                      in
                      {
                        registry = "ghcr.io";
                        repository = "oliver006/redis_exporter";
                        tag = image.imageTag;
                      };
                  };
              };
              extraDeploy = [
                {
                  apiVersion = "monitoring.coreos.com/v1";
                  kind = "PodMonitor";
                  metadata = {
                    name = "${namespace}-valkey-prometheus-podmonitor";
                    namespace = "monitoring";
                    labels.release = "prometheus";
                  };
                  spec = {
                    selector.matchLabels = {
                      "app.kubernetes.io/name" = "valkey";
                      "app.kubernetes.io/instance" = "${namespace}-valkey";
                    };
                    namespaceSelector.matchNames = [ namespace ];
                    podMetricsEndpoints = [
                      { port = "metrics"; }
                    ];
                  };
                }
              ];
            };
          };
        };
      };
    };
}
