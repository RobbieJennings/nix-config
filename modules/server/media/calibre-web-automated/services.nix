{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.calibre-web-automated-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.calibre-web-automated.enable) {
        services.k3s.manifests.calibre-web-automated.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "calibre-web-automated-lb";
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
                "app" = "calibre-web-automated";
              };
              ports = [
                {
                  name = "http";
                  port = 8083;
                  targetPort = 8083;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "calibre-web-automated";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "calibre-web-automated";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8083;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "calibre-web-automated";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "calibre-web-automated";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
