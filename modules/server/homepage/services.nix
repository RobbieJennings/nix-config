{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.homepage.enable {
        services.k3s.manifests.homepage.content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "homepage-lb";
              namespace = "homepage";
              annotations = {
                "metallb.io/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.1.200";
              selector = {
                "app" = "homepage";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 3000;
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "homepage";
              namespace = "homepage";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "homepage";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 3000;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "homepage";
              namespace = "homepage";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef = {
                name = "homepage";
                namespace = "homepage";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
