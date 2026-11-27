{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.freshrss = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.207";
          description = "MetalLB IP address for FreshRSS";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 80;
          description = "MetalLB port for FreshRSS";
        };
      };

      config = lib.mkIf config.freshrss.enable {
        services.k3s.manifests.freshrss.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "freshrss-lb";
              namespace = "freshrss";
              annotations = {
                "metallb.io/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.freshrss.loadBalancerIP;
              selector = {
                "app" = "freshrss";
              };
              ports = [
                {
                  name = "http";
                  port = config.freshrss.loadBalancerPort;
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
              name = "freshrss";
              namespace = "freshrss";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "freshrss";
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
              name = "freshrss";
              namespace = "freshrss";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "freshrss";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
