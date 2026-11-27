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
      options.media-server.transmission = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Transmission";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 9091;
          description = "MetalLB port for Transmission";
        };
        loadBalancerPeerPort = lib.mkOption {
          type = lib.types.int;
          default = 51413;
          description = "MetalLB port for Transmission peers";
        };
      };

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
              loadBalancerIP = config.media-server.transmission.loadBalancerIP;
              selector = {
                "app" = "transmission";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.transmission.loadBalancerPort;
                  targetPort = 9091;
                }
                {
                  name = "peer";
                  port = config.media-server.transmission.loadBalancerPeerPort;
                  targetPort = 51413;
                  protocol = "TCP";
                }
                {
                  name = "peer-udp";
                  port = config.media-server.transmission.loadBalancerPeerPort;
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
              serviceRef.name = "transmission";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
