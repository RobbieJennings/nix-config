{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.seerr-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.seerr = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Seerr";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 5055;
          description = "MetalLB port for Seerr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.seerr.enable) {
        services.k3s.manifests.seerr.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "seerr-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.seerr.loadBalancerIP;
              selector = {
                "app" = "seerr";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.seerr.loadBalancerPort;
                  targetPort = 5055;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "seerr";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "seerr";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 5055;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "seerr";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "seerr";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
