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
              loadBalancerIP = "192.168.1.202";
              selector = {
                "app" = "sonarr";
              };
              ports = [
                {
                  name = "http";
                  port = 8989;
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
              serviceRef = {
                name = "sonarr";
                namespace = "media";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
