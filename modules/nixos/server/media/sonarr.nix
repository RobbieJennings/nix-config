{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.media.sonarr.enable = lib.mkEnableOption "sonarr manifest on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.sonarr.enable) {
    services.k3s = {
      manifests.sonarr.content = [
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "sonarr-config";
            namespace = "media";
          };
          spec = {
            accessModes = [ "ReadWriteOnce" ];
            storageClassName = "longhorn";
            resources.requests.storage = "5Gi";
          };
        }
        {
          apiVersion = "apps/v1";
          kind = "Deployment";
          metadata = {
            name = "sonarr";
            namespace = "media";
          };
          spec = {
            replicas = 1;
            selector.matchLabels.app = "sonarr";
            template = {
              metadata.labels.app = "sonarr";
              spec = {
                containers = [
                  {
                    name = "sonarr";
                    image = "linuxserver/sonarr:latest";
                    ports = [ { containerPort = 8989; } ];
                    volumeMounts = [
                      {
                        name = "config";
                        mountPath = "/config";
                      }
                      {
                        name = "videos";
                        mountPath = "/tv";
                      }
                      {
                        name = "downloads";
                        mountPath = "/downloads";
                      }
                    ];
                  }
                ];
                volumes = [
                  {
                    name = "config";
                    persistentVolumeClaim.claimName = "sonarr-config";
                  }
                  {
                    name = "videos";
                    persistentVolumeClaim.claimName = "media";
                  }
                  {
                    name = "downloads";
                    persistentVolumeClaim.claimName = "downloads";
                  }
                ];
              };
            };
          };
        }
        {
          apiVersion = "v1";
          kind = "Service";
          metadata = {
            name = "sonarr-lb";
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
              "app" = "sonarr";
            };
            ports = [
              {
                name = "http";
                port = 8989;
                targetPort = 8989;
                protocol = "TCP";
              }
            ];
          };
        }
      ];
    };
  };
}
