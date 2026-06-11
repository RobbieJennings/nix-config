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
              loadBalancerIP = "192.168.1.210";
              selector = {
                "app.kubernetes.io/name" = "loki";
                "app.kubernetes.io/instance" = "loki";
              };
              ports = [
                {
                  name = "http";
                  port = 3100;
                  targetPort = 3100;
                }
              ];
            };
          }
        ];
      };
    };
}
