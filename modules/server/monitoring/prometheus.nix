{
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "kube-prometheus-stack";
        repo = "https://prometheus-community.github.io/helm-charts";
        version = "82.2.0";
        hash = "sha256-/HnGrYhMeKjzSrEl+ZZjfGjTJkzzSkXVdb1u+3h9FPA=";
      };
      prometheusImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/prometheus";
        imageDigest = "sha256:1f0f50f06acaceb0f5670d2c8a658a599affe7b0d8e78b898c1035653849a702";
        sha256 = "sha256-Su3crKD8nKz5HBSZtoF+kmG02Xo3mbxXhVZho+DI2TM=";
        finalImageTag = "v3.9.1";
        arch = "amd64";
      };
      alertmanagerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/alertmanager";
        imageDigest = "sha256:88b605de9aba0410775c1eb3438f951115054e0d307f23f274a4c705f51630c1";
        sha256 = "sha256-i19iszdS4OhtI3k8T3+58kUiXI+wkmd4wXdpEntP8GM=";
        finalImageTag = "v0.31.1";
        arch = "amd64";
      };
      nodeExporterImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/node-exporter";
        imageDigest = "sha256:337ff1d356b68d39cef853e8c6345de11ce7556bb34cda8bd205bcf2ed30b565";
        sha256 = "sha256-Us01w7MzoSLV6441UT+TqTZ7pyZubg1KpTi/qfXFQ/o=";
        finalImageTag = "v1.10.2";
        arch = "amd64";
      };
      kubeStateMetricsImage = pkgs.dockerTools.pullImage {
        imageName = "registry.k8s.io/kube-state-metrics/kube-state-metrics";
        imageDigest = "sha256:1545919b72e3ae035454fc054131e8d0f14b42ef6fc5b2ad5c751cafa6b2130e";
        sha256 = "sha256-7zJYcxg+KQtO20erjX5y9X1ymZdNSaJC8jiGnvRiS+s=";
        finalImageTag = "v2.18.0";
        arch = "amd64";
      };
      prometheusOperatorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-operator";
        imageDigest = "sha256:fea93ca9be807eee2f51f4d997b7a2bf073d4051d9012b45b3c84a7b9e8b3f25";
        sha256 = "sha256-p6wbIXZDNNrlZSThijJesNfHv8g0gbESHNWJ6mdo3L8=";
        finalImageTag = "v0.89.0";
        arch = "amd64";
      };
      prometheusConfigReloaderImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-config-reloader";
        imageDigest = "sha256:cb4ac6a56555bef0e202bec11e367dfe07ffb241cf4d30566b12b864692607a8";
        sha256 = "sha256-prJBNjYPBebiR79pX98dcwCX6Gun0iyFichSoFEnuJ4=";
        finalImageTag = "v0.89.0";
        arch = "amd64";
      };
    in
    {
      options = {
        monitoring.prometheus.enable = lib.mkEnableOption "prometheus service on k3s";
      };

      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s = {
          images = [
            prometheusImage
            alertmanagerImage
            nodeExporterImage
            kubeStateMetricsImage
            prometheusOperatorImage
            prometheusConfigReloaderImage
          ];
          autoDeployCharts.prometheus = chart // {
            targetNamespace = "monitoring";
            createNamespace = true;
            values = {
              grafana.enabled = false;
              prometheus = {
                prometheusSpec = {
                  replicas = 1;
                  image = {
                    registry = "quay.io";
                    repository = "prometheus/prometheus";
                    tag = prometheusImage.imageTag;
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
                    tag = alertmanagerImage.imageTag;
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
                  tag = kubeStateMetricsImage.imageTag;
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
                  tag = nodeExporterImage.imageTag;
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
                  tag = prometheusOperatorImage.imageTag;
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
                    tag = prometheusConfigReloaderImage.imageTag;
                  };
                };
              };
            };
            extraDeploy = [
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "prometheus-lb";
                  namespace = "monitoring";
                  annotations = {
                    "metallb.io/address-pool" = "default";
                    "metallb.io/allow-shared-ip" = "monitoring";
                  };
                };
                spec = {
                  type = "LoadBalancer";
                  loadBalancerIP = "192.168.1.210";
                  selector = {
                    "app.kubernetes.io/name" = "prometheus";
                    "app.kubernetes.io/instance" = "prometheus-kube-prometheus-prometheus";
                  };
                  ports = [
                    {
                      name = "http";
                      port = 9090;
                      targetPort = 9090;
                    }
                  ];
                };
              }
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "prometheus";
                  namespace = "monitoring";
                };
                spec = {
                  type = "ClusterIP";
                  selector = {
                    "app.kubernetes.io/name" = "prometheus";
                    "app.kubernetes.io/instance" = "prometheus-kube-prometheus-prometheus";
                  };
                  ports = [
                    {
                      name = "http";
                      port = 80;
                      targetPort = 9090;
                      protocol = "TCP";
                    }
                  ];
                };
              }
              {
                apiVersion = "netbird.io/v1alpha1";
                kind = "NetworkResource";
                metadata = {
                  name = "prometheus";
                  namespace = "monitoring";
                };
                spec = {
                  networkRouterRef = {
                    name = "homelab";
                    namespace = "netbird";
                  };
                  serviceRef = {
                    name = "prometheus";
                    namespace = "monitoring";
                  };
                  groups = [ { name = "All"; } ];
                };
              }
            ];
          };
        };
      };
    };
}
