{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.longhorn.enable = lib.mkEnableOption "longhorn helm chart on k3s";
  };

  config = lib.mkIf config.server.longhorn.enable {
    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
    systemd.services.iscsid.serviceConfig = {
      PrivateMounts = "yes";
      BindPaths = "/run/current-system/sw/bin:/bin";
    };
    services.k3s = {
      autoDeployCharts.longhorn = {
        name = "longhorn";
        repo = "https://charts.longhorn.io";
        version = "1.10.0";
        hash = "sha256-K+nao6QNuX6R/WoyrtCly9kXvUHwsA3h5o8KmOajqAs=";
        createNamespace = true;
        targetNamespace = "longhorn-system";
        values = {
          # TODO
        };
        extraDeploy = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "longhorn-tcp";
              namespace = "longhorn-system";
              annotations = {
                "metallb.universe.tf/address-pool" = "default";
              };
            };
            spec = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.0.202";
              selector = {
                "app" = "longhorn-ui";
              };
              ports = [
                {
                  port = 80;
                  targetPort = 8000;
                  protocol = "TCP";
                }
              ];
            };
          }
        ];
      };
    };
  };
}
