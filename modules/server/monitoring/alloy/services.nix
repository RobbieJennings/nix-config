{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.alloy-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s.autoDeployCharts.alloy = {
          values.service.enabled = false;
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
}
