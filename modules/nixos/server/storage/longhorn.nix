{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.storage.longhorn.enable = lib.mkEnableOption "longhorn helm chart on k3s";
  };

  config = lib.mkIf (config.server.storage.enable && config.server.storage.longhorn.enable) {
    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];
    environment.systemPackages = [
      pkgs.util-linux
      pkgs.nfs-utils
    ];
    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
    services.k3s = {
      autoDeployCharts.longhorn = {
        name = "longhorn";
        repo = "https://charts.longhorn.io";
        version = "1.10.0";
        hash = "sha256-K+nao6QNuX6R/WoyrtCly9kXvUHwsA3h5o8KmOajqAs=";
        targetNamespace = "longhorn-system";
        createNamespace = true;
        values = {
          defaultSettings.defaultReplicaCount = "1";
          longhornUI.replicas = 1;
          persistence = {
            defaultClassReplicaCount = 1;
            reclaimPolicy = "Retain";
          };
          csi = {
            attacherReplicaCount = "1";
            provisionerReplicaCount = "1";
            resizerReplicaCount = "1";
            snapshotterReplicaCount = "1";
          };
        };
        extraDeploy = [
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
              loadBalancerIP = "192.168.0.201";
              selector = {
                "app" = "longhorn-ui";
              };
              ports = [
                {
                  name = "http";
                  port = 8000;
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
