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
      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s.autoDeployCharts.prometheus = {
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
}
