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
              loadBalancerIP = "192.168.1.202";
              selector = {
                "app" = "prowlarr";
              };
              ports = [
                {
                  name = "http";
                  port = 9696;
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
              serviceRef = {
                name = "prowlarr";
                namespace = "media";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
