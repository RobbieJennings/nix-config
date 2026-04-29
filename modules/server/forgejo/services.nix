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
        services.k3s.autoDeployCharts.forgejo = {
          values.service = {
            http = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.1.204";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "forgejo";
              };
            };
            ssh = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.1.204";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "forgejo";
              };
            };
          };
          extraDeploy = [
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
                serviceRef = {
                  name = "forgejo";
                  namespace = "forgejo";
                };
                groups = [ { name = "All"; } ];
              };
            }
          ];
        };
      };
    };
}
