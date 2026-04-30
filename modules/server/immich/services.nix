{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.immich.enable {
        services.k3s.autoDeployCharts.immich = {
          values.service.main = {
            type = "LoadBalancer";
            annotations = {
              "metallb.io/address-pool" = "default";
              "metallb.io/allow-shared-ip" = "immich";
              "metallb.io/loadBalancerIPs" = "192.168.1.205";
            };
          };
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "immich";
                namespace = "immich";
              };
              spec = {
                type = "ClusterIP";
                selector = {
                  "app.kubernetes.io/controller" = "main";
                  "app.kubernetes.io/instance" = "immich";
                  "app.kubernetes.io/name" = "server";
                };
                ports = [
                  {
                    name = "http";
                    port = 80;
                    targetPort = 2283;
                    protocol = "TCP";
                  }
                ];
              };
            }
            {
              apiVersion = "netbird.io/v1alpha1";
              kind = "NetworkResource";
              metadata = {
                name = "immich";
                namespace = "immich";
              };
              spec = {
                networkRouterRef = {
                  name = "homelab";
                  namespace = "netbird";
                };
                serviceRef = {
                  name = "immich";
                  namespace = "immich";
                };
                groups = [ { name = "All"; } ];
              };
            }
          ];
        };
      };
    };
}
