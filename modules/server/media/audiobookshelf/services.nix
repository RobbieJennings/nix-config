{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.audiobookshelf-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.audiobookshelf.enable) {
        services.k3s.manifests.audiobookshelf.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "audiobookshelf-lb";
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
                "app" = "audiobookshelf";
              };
              ports = [
                {
                  name = "http";
                  port = 13378;
                  targetPort = 80;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "audiobookshelf";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "audiobookshelf";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 80;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "audiobookshelf";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "audiobookshelf";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
