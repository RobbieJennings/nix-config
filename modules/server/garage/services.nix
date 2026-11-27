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
      options.garage = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.208";
          description = "MetalLB IP address for Garage";
        };
        loadBalancerApiPort = lib.mkOption {
          type = lib.types.int;
          default = 3900;
          description = "MetalLB port for Garage API";
        };
        loadBalancerWebPort = lib.mkOption {
          type = lib.types.int;
          default = 3902;
          description = "MetalLB port for Garage Web";
        };
        loadBalancerAdminPort = lib.mkOption {
          type = lib.types.int;
          default = 3903;
          description = "MetalLB port for Garage Admin";
        };
        loadBalancerUIPort = lib.mkOption {
          type = lib.types.int;
          default = 3909;
          description = "MetalLB port for Garage Web UI";
        };
      };

      config = lib.mkIf config.garage.enable {
        services.k3s.autoDeployCharts.garage.extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "garage-lb";
              namespace = "garage";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "garage";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = config.garage.loadBalancerIP;
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
                {
                  name = "admin";
                  port = 3903;
                  targetPort = 3903;
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
              serviceRef.name = "garage";
              groups = [ { name = "All"; } ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "garage-web-ui-lb";
              namespace = "garage";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.io/allow-shared-ip" = "garage";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.1.208";
              selector = {
                "app" = "garage-web-ui";
              };
              ports = [
                {
                  name = "http";
                  port = config.garage.loadBalancerUIPort;
                  targetPort = 3909;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "garage-web-ui";
              namespace = "garage";
            };
            spec = {
              type = "ClusterIP";
              selector = {
                "app" = "garage-web-ui";
              };
              ports = [
                {
                  name = "http";
                  port = 80;
                  targetPort = 3909;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkResource";
            metadata = {
              name = "garage-web-ui";
              namespace = "garage";
            };
            spec = {
              networkRouterRef = {
                name = "homelab";
                namespace = "netbird";
              };
              serviceRef.name = "garage-web-ui";
              groups = [ { name = "All"; } ];
            };
          }
        ];
      };
    };
}
