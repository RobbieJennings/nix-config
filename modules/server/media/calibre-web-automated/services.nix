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
      options.media-server.calibre-web-automated = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.202";
          description = "MetalLB IP address for Calibre-Web-Automated";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 8083;
          description = "MetalLB port for Calibre-Web-Automated";
        };
      };

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
              loadBalancerIP = config.media-server.calibre-web-automated.loadBalancerIP;
              selector = {
                "app" = "calibre-web-automated";
              };
              ports = [
                {
                  name = "http";
                  port = config.media-server.calibre-web-automated.loadBalancerPort;
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
