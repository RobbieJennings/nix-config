{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.longhorn = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.201";
          description = "MetalLB IP address for Longhorn";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 80;
          description = "MetalLB port for Longhorn";
        };
      };
      config = lib.mkIf config.longhorn.enable {
        services.k3s.autoDeployCharts.longhorn.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "longhorn-lb";
              namespace = "longhorn-system";
              annotations = {
                "metallb.io/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.longhorn.loadBalancerIP;
              selector = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
                "app" = "longhorn-ui";
              };
              ports = [
                {
                  name = "http";
                  port = config.longhorn.loadBalancerPort;
                  targetPort = 8000;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "longhorn";
              namespace = "longhorn-system";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
                "app" = "longhorn-ui";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8000;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "longhorn";
              namespace = "longhorn-system";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "longhorn";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
