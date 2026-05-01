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
              loadBalancerIP = "192.168.1.202";
              selector = {
                "app" = "radarr";
              };
              ports = [
                {
                  name = "http";
                  port = 7878;
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
              serviceRef = {
                name = "radarr";
                namespace = "media";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
