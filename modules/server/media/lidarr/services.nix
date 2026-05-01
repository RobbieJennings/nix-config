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
              loadBalancerIP = "192.168.1.202";
              selector = {
                "app" = "lidarr";
              };
              ports = [
                {
                  name = "http";
                  port = 8686;
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
              serviceRef = {
                name = "lidarr";
                namespace = "media";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
