{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.longhorn.enable {
        services.k3s.autoDeployCharts.longhorn.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "longhorn-lb";
              namespace = "longhorn-system";
              annotations = {
                "metallb.io/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.1.201";
              selector = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
                "app" = "longhorn-ui";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8000;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "longhorn";
              namespace = "longhorn-system";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
                "app" = "longhorn-ui";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 8000;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "longhorn";
              namespace = "longhorn-system";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "longhorn";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
