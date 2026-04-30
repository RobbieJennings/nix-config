{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.autoDeployCharts.grafana = {
          values.service.enable = false;
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "grafana-lb";
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
                  "app.kubernetes.io/name" = "grafana";
                  "app.kubernetes.io/instance" = "grafana";
                };
                ports = [
                  {
                    name = "http";
                    port = 3000;
                    targetPort = 3000;
                  }
                ];
              };
            }
            {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "grafana";
                namespace = "monitoring";
              };
              spec = {
                type = "ClusterIP";
                selector = {
                  "app.kubernetes.io/name" = "grafana";
                  "app.kubernetes.io/instance" = "grafana";
                };
                ports = [
                  {
                    name = "http";
                    port = 80;
                    targetPort = 3000;
                    protocol = "TCP";
                  }
                ];
              };
            }
            {
              apiVersion = "netbird.io/v1alpha1";
              kind = "NetworkResource";
              metadata = {
                name = "grafana";
                namespace = "monitoring";
              };
              spec = {
                networkRouterRef = {
                  name = "homelab";
                  namespace = "netbird";
                };
                serviceRef = {
                  name = "grafana";
                  namespace = "monitoring";
                };
                groups = [ { name = "All"; } ];
              };
            }
          ];
        };
      };
    };
}
