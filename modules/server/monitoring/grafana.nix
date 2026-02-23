{
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "grafana";
        repo = "https://grafana-community.github.io/helm-charts";
        version = "11.1.7";
        hash = "sha256-KSHxBROOLZeaf7CeqFm6mStp58AnRgQaclWRHyJL/FU=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "grafana/grafana";
        imageDigest = "sha256:62a54c76afbeea0b8523b7afcd9e7ee1f0e39806035fd90ffc333a19e9358f2f";
        sha256 = "sha256-OhTmnRsqpgJbNxOD4zNUehEaX2l28HNxKJ9Nec2XLfs=";
        finalImageTag = "12.3.3";
        arch = "amd64";
      };
    in
    {
      options = {
        monitoring.grafana.enable = lib.mkEnableOption "prometheus service on k3s";
        secrets.grafana.enable = lib.mkEnableOption "grafana secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.monitoring.grafana.enable {
          services.k3s = {
            images = [ image ];
            autoDeployCharts.grafana = chart // {
              targetNamespace = "monitoring";
              createNamespace = true;
              values = {
                replicas = 1;
                image = {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
                adminUser = "admin";
                adminPassword = "changeme";
                admin =
                  if (config.secrets.enable && config.secrets.grafana.enable) then
                    {
                      existingSecret = "grafana-secrets";
                    }
                  else
                    { };
                persistence = {
                  enabled = true;
                  storageClassName = "longhorn";
                  size = "10Gi";
                };
                service = {
                  type = "LoadBalancer";
                  loadBalancerIP = "192.168.0.210";
                  annotations = {
                    "metallb.io/address-pool" = "default";
                    "metallb.io/allow-shared-ip" = "monitoring";
                  };
                };
                resources = {
                  requests.cpu = "100m";
                  requests.memory = "256Mi";
                  limits.cpu = "500m";
                  limits.memory = "512Mi";
                };
                datasources = {
                  "datasources.yaml" = {
                    apiVersion = 1;
                    datasources = [
                      {
                        name = "Prometheus";
                        type = "prometheus";
                        access = "proxy";
                        url = "http://192.168.0.210:9090";
                        isDefault = true;
                        editable = false;
                      }
                      {
                        name = "Loki";
                        type = "loki";
                        access = "proxy";
                        url = "http://192.168.0.210:3100";
                        editable = false;
                      }
                    ];
                  };
                };
              };
            };
          };
        })
        (lib.mkIf
          (config.monitoring.grafana.enable && config.secrets.enable && config.secrets.grafana.enable)
          {
            sops = {
              secrets = {
                "grafana/username" = { };
                "grafana/password" = { };
              };
              templates.grafanaSecrets = {
                content = builtins.toJSON {
                  apiVersion = "v1";
                  kind = "Secret";
                  type = "Opaque";
                  metadata = {
                    name = "grafana-secrets";
                    namespace = "monitoring";
                  };
                  stringData = {
                    admin-user = config.sops.placeholder."grafana/username";
                    admin-password = config.sops.placeholder."grafana/password";
                  };
                };
                path = "/var/lib/rancher/k3s/server/manifests/grafana-secret.json";
              };
            };
          }
        )
      ];
    };
}
