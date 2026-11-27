{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.loki-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.monitoring.loki = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.210";
          description = "MetalLB IP address for Loki";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 3100;
          description = "MetalLB port for Loki";
        };
      };

      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s.autoDeployCharts.loki.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "loki-lb";
              namespace = "monitoring";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "monitoring";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.monitoring.loki.loadBalancerIP;
              selector = {
                "app.kubernetes.io/name" = "loki";
                "app.kubernetes.io/instance" = "loki";
              };
              ports = [
                {
                  name = "http";
                  port = config.monitoring.loki.loadBalancerPort;
                  targetPort = 3100;
                }
              ];
            };
          }
        ];
      };
    };
}
