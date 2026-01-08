{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  image = pkgs.dockerTools.pullImage {
    imageName = "linuxserver/transmission";
    imageDigest = "sha256:978b9e0b06eda2cfed79c861fc8ca440b8b29e45dc9dc2522daa67c3818a0d88";
    sha256 = "sha256-uQWuUyhumbEmxTgYzhWtLjg6z+67qQqlRZ2W134ZHbA=";
    finalImageTag = "4.0.6";
    arch = "amd64";
  };
in
{
  options = {
    server.media.transmission.enable = lib.mkEnableOption "transmission manifest on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.transmission.enable) {
    services.k3s = {
      images = [ image ];
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
                securityContext = {
                  runAsUser = 1000;
                  runAsGroup = 1000;
                  fsGroup = 1000;
                };
                containers = [
                  {
                    name = "transmission";
                    image = "${image.imageName}:${image.imageTag}";
                    env = [
                      {
                        name = "PUID";
                        value = "1000";
                      }
                      {
                        name = "PGID";
                        value = "1000";
                      }
                    ];
                    ports = [ { containerPort = 9091; } ];
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
              "metallb.io/allow-shared-ip" = "media";
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
