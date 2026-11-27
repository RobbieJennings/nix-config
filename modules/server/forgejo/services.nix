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
      options.forgejo = {
        loadBalancerIP = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.204";
          description = "MetalLB IP address for Forgejo";
        };
        loadBalancerPort = lib.mkOption {
          type = lib.types.int;
          default = 3000;
          description = "MetalLB port for Forgejo";
        };
        loadBalancerSshPort = lib.mkOption {
          type = lib.types.int;
          default = 22;
          description = "MetalLB ssh port for Forgejo";
        };
      };

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
              inherit (config.forgejo.loadBalancerIP) ;
              selector = {
                "app.kubernetes.io/name" = "forgejo";
                "app.kubernetes.io/instance" = "forgejo";
                "app" = "forgejo";
              };
              ports = [
                {
                  name = "http";
                  port = config.forgejo.loadBalancerPort;
                  targetPort = 3000;
                  protocol = "TCP";
                }
                {
                  name = "ssh";
                  port = config.forgejo.loadBalancerSshPort;
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
