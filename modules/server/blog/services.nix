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
              loadBalancerIP = "192.168.1.209";
              selector = {
                "app" = "blog";
              };
              ports = [
                {
                  name = "http";
                  port = 8080;
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
              serviceRef = {
                name = "blog";
                namespace = "website";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
