{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.homepage = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.200";
          description = "MetalLB IP address for Homepage";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 80;
          description = "MetalLB port for Homepage";
        };
      };

      config = lib.mkIf config.homepage.enable {
        services.k3s.manifests.homepage.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "homepage-lb";
              namespace = "homepage";
              annotations = {
                "metallb.io/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.homepage.loadBalancerIP;
              selector = {
                "app" = "homepage";
              };
              ports = [
                {
                  name = "http";
                  port = config.homepage.loadBalancerPort;
                  targetPort = 3000;
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "homepage";
              namespace = "homepage";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "homepage";
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
              name = "homepage";
              namespace = "homepage";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "homepage";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
