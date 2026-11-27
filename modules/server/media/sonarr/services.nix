{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.sonarr = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Sonarr";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 8989;
          description = "MetalLB port for Sonarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.sonarr.enable) {
        services.k3s.manifests.sonarr.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "sonarr-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.sonarr.loadBalancerIP;
              selector = {
                "app" = "sonarr";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.sonarr.loadBalancerPort;
                  targetPort = 8989;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "sonarr";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "sonarr";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8989;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "sonarr";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "sonarr";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
