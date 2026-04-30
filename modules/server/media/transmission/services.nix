{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.transmission-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.transmission.enable) {
        services.k3s.manifests.transmission.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "transmission-lb";
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
                "app" = "transmission";
              };
              ports = [
                {
                  name = "http";
                  port = 9091;
                  targetPort = 9091;
                }
                {
                  name = "peer";
                  port = 51413;
                  targetPort = 51413;
                  protocol = "TCP";
                }
                {
                  name = "peer-udp";
                  port = 51413;
                  targetPort = 51413;
                  protocol = "UDP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "transmission";
              namespace = "media";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "transmission";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 9091;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "transmission";
              namespace = "media";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef = {
                name = "transmission";
                namespace = "media";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
