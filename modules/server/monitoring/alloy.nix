{
  inputs,
  ...
}:
{
  flake.modules.nixos.alloy =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "alloy";
        repo = "https://grafana.github.io/helm-charts";
        version = "1.6.2";
        hash = "sha256-GE9XmX2Ks8nICygroipZw813Xq3GDWrL2bzMJ8GuOUc=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "grafana/alloy";
        imageDigest = "sha256:f50931848bd8178774521767bb46b905e1a081301950ff28d7623c9db7c01076";
        sha256 = "sha256-8xbnqldN9qEe3tXmfsy43k5j2gqYROYOqHWivGNjFaw=";
        finalImageTag = "v1.14.0";
        arch = "amd64";
      };
    in
    {
      options = {
        monitoring.alloy.enable = lib.mkEnableOption "alloy service on k3s";
      };

      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s = {
          images = [ image ];
          autoDeployCharts.alloy = chart // {
            targetNamespace = "monitoring";
            createNamespace = true;
            values = {
              image = {
                repository = image.imageName;
                tag = image.imageTag;
              };
              alloy = {
                configMap = {
                  create = true;
                  content = ''
                    logging {
                      level = "info"
                    }
                    discovery.kubernetes "pods" {
                      role = "pod"
                    }
                    loki.source.kubernetes "pods" {
                      targets = discovery.kubernetes.pods.targets
                      forward_to = [loki.write.default.receiver]
                    }
                    loki.write "default" {
                      endpoint {
                        url = "http://192.168.1.210:3100/loki/api/v1/push"
                      }
                    }
                  '';
                };
              };
              service.enabled = false;
              resources = {
                requests.cpu = "20m";
                requests.memory = "64Mi";
                limits.cpu = "200m";
                limits.memory = "256Mi";
              };
            };
            extraDeploy = [
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "alloy-lb";
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
                    "app.kubernetes.io/name" = "alloy";
                    "app.kubernetes.io/instance" = "alloy";
                  };
                  ports = [
                    {
                      name = "http";
                      port = 12345;
                      targetPort = 12345;
                    }
                  ];
                };
              }
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "alloy";
                  namespace = "monitoring";
                };
                spec = {
                  type = "ClusterIP";
                  selector = {
                    "app.kubernetes.io/name" = "alloy";
                    "app.kubernetes.io/instance" = "alloy";
                  };
                  ports = [
                    {
                      name = "http";
                      port = 80;
                      targetPort = 12345;
                      protocol = "TCP";
                    }
                  ];
                };
              }
              {
                apiVersion = "netbird.io/v1alpha1";
                kind = "NetworkResource";
                metadata = {
                  name = "alloy";
                  namespace = "monitoring";
                };
                spec = {
                  networkRouterRef = {
                    name = "homelab";
                    namespace = "netbird";
                  };
                  serviceRef = {
                    name = "alloy";
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
