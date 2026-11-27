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
      options.monitoring.alloy = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.210";
          description = "MetalLB IP address for Alloy";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 12345;
          description = "MetalLB port for Alloy";
        };
      };

      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s.autoDeployCharts.alloy.extraDeploy = [
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
              loadBalancerIP = config.monitoring.alloy.loadBalancerIP;
              selector = {
                "app.kubernetes.io/name" = "alloy";
                "app.kubernetes.io/instance" = "alloy";
              };
              ports = [
                {
                  name = "http";
                  port = config.monitoring.alloy.loadBalancerPort;
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
              serviceRef.name = "alloy";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
