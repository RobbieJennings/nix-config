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
              loadBalancerIP = "192.168.1.202";
              selector = {
                "app" = "flaresolverr";
              };
              ports = [
                {
                  name = "http";
                  port = 8191;
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
