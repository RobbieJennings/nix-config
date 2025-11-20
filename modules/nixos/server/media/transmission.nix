{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.media.transmission.enable = lib.mkEnableOption "transmission manifest on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.transmission.enable) {
    services.k3s = {
      manifests.transmission.content = [
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "transmission-config";
            namespace = "media";
          };
          spec = {
            accessModes = [ "ReadWriteOnce" ];
            storageClassName = "longhorn";
            resources.requests.storage = "5Gi";
          };
        }
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "transmission-watch";
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
            name = "transmission";
            namespace = "media";
          };
          spec = {
            replicas = 1;
            selector.matchLabels.app = "transmission";
            template = {
              metadata.labels.app = "transmission";
              spec = {
                containers = [
                  {
                    name = "transmission";
                    image = "linuxserver/transmission:latest";
                    ports = [
                      {
                        containerPort = 9091;
                        name = "http";
                      }
                    ];
                    volumeMounts = [
                      {
                        name = "config";
                        mountPath = "/config";
                      }
                      {
                        name = "watch";
                        mountPath = "/watch";
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
                    persistentVolumeClaim.claimName = "transmission-config";
                  }
                  {
                    name = "watch";
                    persistentVolumeClaim.claimName = "transmission-watch";
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
            name = "transmission-lb";
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
              "app" = "transmission";
            };
            ports = [
              {
                name = "http";
                port = 9091;
                targetPort = 9091;
              }
              {
                name = "peer";
                port = 51413;
                targetPort = 51413;
                protocol = "TCP";
              }
              {
                name = "peer-udp";
                port = 51413;
                targetPort = 51413;
                protocol = "UDP";
              }
            ];
          };
        }
      ];
    };
  };
}
