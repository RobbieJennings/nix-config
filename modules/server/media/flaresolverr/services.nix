{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.flaresolverr-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.flaresolverr = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Flaresolverr";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 8191;
          description = "MetalLB port for Flaresolverr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.flaresolverr.enable) {
        services.k3s.manifests.flaresolverr.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "flaresolverr-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.media-server.flaresolverr.loadBalancerIP;
              selector = {
                "app" = "flaresolverr";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.flaresolverr.loadBalancerPort;
                  targetPort = 8191;
                  protocol = "TCP";
                }
              ];
            };
          }
        ];
      };
    };
}
