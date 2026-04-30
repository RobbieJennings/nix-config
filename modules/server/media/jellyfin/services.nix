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
              loadBalancerIP = "192.168.1.202";
              selector = {
                "app" = "jellyfin";
              };
              ports = [
                {
                  name = "http";
                  port = 8096;
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
              serviceRef = {
                name = "jellyfin";
                namespace = "media";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
