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
              loadBalancerIP = "192.168.1.202";
              selector = {
                "app" = "shelfmark";
              };
              ports = [
                {
                  name = "http";
                  port = 8084;
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
