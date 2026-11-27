{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.blog-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.blog = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.209";
          description = "MetalLB IP address for Blog";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 8080;
          description = "MetalLB port for Blog";
        };
      };

      config = lib.mkIf config.blog.enable {
        services.k3s.manifests.blog.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "blog-lb";
              namespace = "website";
              annotations = {
                "metallb.io/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.blog.loadBalancerIP;
              selector = {
                "app" = "blog";
              };
              ports = [
                {
                  name = "http";
                  port = config.blog.loadBalancerPort;
                  targetPort = 8080;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "blog";
              namespace = "website";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "blog";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8080;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "blog";
              namespace = "website";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "blog";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
