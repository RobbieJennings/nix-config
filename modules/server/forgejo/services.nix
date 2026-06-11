{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s.autoDeployCharts.forgejo.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "forgejo-lb";
              namespace = "forgejo";
              annotations = {
                "metallb.io/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.1.204";
              selector = {
                "app.kubernetes.io/name" = "forgejo";
                "app.kubernetes.io/instance" = "forgejo";
                "app" = "forgejo";
              };
              ports = [
                {
                  name = "http";
                  port = 3000;
                  targetPort = 3000;
                  protocol = "TCP";
                }
                {
                  name = "ssh";
                  port = 22;
                  targetPort = 2222;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "forgejo";
              namespace = "forgejo";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app.kubernetes.io/name" = "forgejo";
                "app.kubernetes.io/instance" = "forgejo";
                "app" = "forgejo";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 3000;
                  protocol = "TCP";
                }
                {
                  name = "ssh";
                  port = 22;
                  targetPort = 2222;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "forgejo";
              namespace = "forgejo";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "forgejo";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
