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
              loadBalancerIP = "192.168.1.207";
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
