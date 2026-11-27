{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.lidarr-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.lidarr = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Lidarr";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 8686;
          description = "MetalLB port for Lidarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.lidarr.enable) {
        services.k3s.manifests.lidarr.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "lidarr-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.lidarr.loadBalancerIP;
              selector = {
                "app" = "lidarr";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.lidarr.loadBalancerPort;
                  targetPort = 8686;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "lidarr";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "lidarr";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8686;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "lidarr";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "lidarr";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
