{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.media.jellyfin.enable = lib.mkEnableOption "jellyfin helm chart on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.jellyfin.enable) {
    services.k3s = {
      manifests.media.content = [
        {
          apiVersion = "v1";
          kind = "Namespace";
          metadata = {
            name = "media";
          };
        }
      ];
      autoDeployCharts.jellyfin = {
        name = "jellyfin";
        repo = "https://jellyfin.github.io/jellyfin-helm";
        version = "2.5.0";
        hash = "sha256-GzyLqPAXGQTVICEeq9RnWs9IF4ceqp9WZR3XLgEEsPU=";
        targetNamespace = "media";
        createNamespace = false;
        values = {
          replicaCount = 1;
          persistence.config = {
            enabled = true;
            size = "5Gi";
          };
          persistence.media = {
            enabled = true;
            existingClaim = "media";
          };
        };
        extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "jellyfin-lb";
              namespace = "media";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.universe.tf/allow-shared-ip" = "media";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.0.202";
              selector = {
                "app.kubernetes.io/name" = "jellyfin";
              };
              ports = [
                {
                  name = "http";
                  port = 8096;
                  targetPort = 8096;
                  protocol = "TCP";
                }
                {
                  name = "service-discovery";
                  port = 1900;
                  targetPort = 1900;
                  protocol = "UDP";
                }
                {
                  name = "client-discovery";
                  port = 7359;
                  targetPort = 7359;
                  protocol = "UDP";
                }
              ];
            };
          }
        ];
      };
    };
  };
}
