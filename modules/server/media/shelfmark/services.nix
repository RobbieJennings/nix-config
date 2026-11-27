{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.shelfmark-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.shelfmark = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Shelfmark";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 8084;
          description = "MetalLB port for Shelfmark";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.shelfmark.enable) {
        services.k3s.manifests.shelfmark.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "shelfmark-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.shelfmark.loadBalancerIP;
              selector = {
                "app" = "shelfmark";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.shelfmark.loadBalancerPort;
                  targetPort = 8084;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "shelfmark";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "shelfmark";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8084;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "shelfmark";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "shelfmark";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
