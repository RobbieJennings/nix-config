{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.jellyfin = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Jellyfin";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 8096;
          description = "MetalLB port for Jellyfin";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.jellyfin.enable) {
        services.k3s.manifests.jellyfin.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "jellyfin-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.jellyfin.loadBalancerIP;
              selector = {
                "app" = "jellyfin";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.jellyfin.loadBalancerPort;
                  targetPort = 8096;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "jellyfin";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "jellyfin";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8096;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "jellyfin";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "jellyfin";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
