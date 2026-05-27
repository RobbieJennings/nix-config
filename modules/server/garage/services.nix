{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage-services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.garage.enable {
        services.k3s.autoDeployCharts.garage = {
          values.service.s3.web.port = 80;
          extraDeploy = [
            {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "garage-lb";
                namespace = "garage";
                annotations = {
                  "metallb.io/address-pool" = "default";
                };
              };
              spec = {
                type = "LoadBalancer";
                loadBalancerIP = "192.168.1.208";
                selector = {
                  "app.kubernetes.io/instance" = "garage";
                  "app.kubernetes.io/name" = "garage";
                };
                ports = [
                  {
                    name = "api";
                    port = 3900;
                    targetPort = 3900;
                    protocol = "TCP";
                  }
                  {
                    name = "web";
                    port = 3902;
                    targetPort = 3902;
                    protocol = "TCP";
                  }
                ];
              };
            }
            {
              apiVersion = "netbird.io/v1alpha1";
              kind = "NetworkResource";
              metadata = {
                name = "garage";
                namespace = "garage";
              };
              spec = {
                networkRouterRef = {
                  name = "homelab";
                  namespace = "netbird";
                };
                serviceRef = {
                  name = "garage";
                  namespace = "garage";
                };
                groups = [ { name = "All"; } ];
              };
            }
          ];
        };
      };
    };
}
