{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.monitoring.prometheus = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.210";
          description = "MetalLB IP address for Prometheus";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 9090;
          description = "MetalLB port for Prometheus";
        };
      };

      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s.autoDeployCharts.prometheus.extraDeploy = [
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
              loadBalancerIP = config.monitoring.prometheus.loadBalancerIP;
              selector = {
                "app.kubernetes.io/name" = "prometheus";
                "app.kubernetes.io/instance" = "prometheus-kube-prometheus-prometheus";
              };
              ports = [
                {
                  name = "http";
                  port = config.monitoring.prometheus.loadBalancerPort;
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
              serviceRef.name = "prometheus";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
