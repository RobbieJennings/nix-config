{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts.nextcloud.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "nextcloud-lb";
              namespace = "nextcloud";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "nextcloud";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.1.203";
              selector = {
                "app.kubernetes.io/component" = "app";
                "app.kubernetes.io/instance" = "nextcloud";
                "app.kubernetes.io/name" = "nextcloud";
              };
              ports = [
                {
                  name = "http";
                  port = 8080;
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
              name = "nextcloud";
              namespace = "nextcloud";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef = {
                name = "nextcloud";
                namespace = "nextcloud";
              };
              groups = [ { name = "All"; } ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "nextcloud-collabora";
              namespace = "nextcloud";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef = {
                name = "nextcloud-collabora";
                namespace = "nextcloud";
              };
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
