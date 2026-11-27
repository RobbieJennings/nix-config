{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prowlarr-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.prowlarr = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Prowlarr";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 9696;
          description = "MetalLB port for Prowlarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.prowlarr.enable) {
        services.k3s.manifests.prowlarr.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "prowlarr-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.prowlarr.loadBalancerIP;
              selector = {
                "app" = "prowlarr";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.prowlarr.loadBalancerPort;
                  targetPort = 9696;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "prowlarr";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "prowlarr";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 9696;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "prowlarr";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "prowlarr";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
