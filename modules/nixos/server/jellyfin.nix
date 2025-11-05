{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.jellyfin.enable = lib.mkEnableOption "jellyfin helm chart on k3s";
  };

  config = lib.mkIf config.server.jellyfin.enable {
    services.k3s = {
      autoDeployCharts.jellyfin = {
        name = "jellyfin";
        repo = "https://jellyfin.github.io/jellyfin-helm";
        version = "2.5.0";
        hash = "sha256-GzyLqPAXGQTVICEeq9RnWs9IF4ceqp9WZR3XLgEEsPU=";
        targetNamespace = "jellyfin";
        createNamespace = true;
        values = {
          # TODO
        };
        extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "jellyfin-tcp";
              namespace = "jellyfin";
              annotations = {
                "metallb.universe.tf/address-pool" = "default";
                "metallb.universe.tf/allow-shared-ip" = "jellyfin-shared";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.0.203";
              selector = {
                "app.kubernetes.io/name" = "jellyfin";
              };
              ports = [
                {
                  port = 80;
                  targetPort = 8096;
                  protocol = "TCP";
                }
              ];
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "jellyfin-udp";
              namespace = "jellyfin";
              annotations = {
                "metallb.universe.tf/address-pool" = "default";
                "metallb.universe.tf/allow-shared-ip" = "jellyfin-shared";
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
                  port = 1900;
                  targetPort = 1900;
                  protocol = "UDP";
                }
                {
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
