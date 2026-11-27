{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.radarr-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.radarr = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Radarr";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 7878;
          description = "MetalLB port for Radarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.radarr.enable) {
        services.k3s.manifests.radarr.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "radarr-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.radarr.loadBalancerIP;
              selector = {
                "app" = "radarr";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.radarr.loadBalancerPort;
                  targetPort = 7878;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "radarr";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "radarr";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 7878;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "radarr";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "radarr";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
