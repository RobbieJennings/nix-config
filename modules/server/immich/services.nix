{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.immich = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.205";
          description = "MetalLB IP address for Immich";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 2283;
          description = "MetalLB port for Immich";
        };
      };

      config = lib.mkIf config.immich.enable {
        services.k3s.autoDeployCharts.immich.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "immich-lb";
              namespace = "immich";
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.immich.loadBalancerIP;
              selector = {
                "app.kubernetes.io/controller" = "main";
                "app.kubernetes.io/instance" = "immich";
                "app.kubernetes.io/name" = "server";
              };
              ports = [
                {
                  name = "http";
                  port = config.immich.loadBalancerPort;
                  targetPort = 2283;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "immich";
              namespace = "immich";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app.kubernetes.io/controller" = "main";
                "app.kubernetes.io/instance" = "immich";
                "app.kubernetes.io/name" = "server";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 2283;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "immich";
              namespace = "immich";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "immich";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
