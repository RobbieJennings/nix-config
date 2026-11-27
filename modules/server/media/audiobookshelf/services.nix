{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.audiobookshelf-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.audiobookshelf = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Audiobookshelf";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 13378;
          description = "MetalLB port for Audiobookshelf";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.audiobookshelf.enable) {
        services.k3s.manifests.audiobookshelf.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "audiobookshelf-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.audiobookshelf.loadBalancerIP;
              selector = {
                "app" = "audiobookshelf";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.audiobookshelf.loadBalancerPort;
                  targetPort = 80;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "audiobookshelf";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "audiobookshelf";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 80;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "audiobookshelf";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "audiobookshelf";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
