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
      options.monitoring.grafana = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.210";
          description = "MetalLB IP address for Grafana";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 3000;
          description = "MetalLB port for Grafana";
        };
      };

      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.autoDeployCharts.grafana.extraDeploy = [
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
              loadBalancerIP = config.monitoring.grafana.loadBalancerIP;
              selector = {
                "app.kubernetes.io/name" = "grafana";
                "app.kubernetes.io/instance" = "grafana";
              };
              ports = [
                {
                  name = "http";
                  port = config.monitoring.grafana.loadBalancerPort;
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
              serviceRef.name = "grafana";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
