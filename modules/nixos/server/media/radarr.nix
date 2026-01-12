{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  image = pkgs.dockerTools.pullImage {
    imageName = "linuxserver/radarr";
    imageDigest = "sha256:e26fbfd3782520c0bb820666f041ca056acfe187a8b95214ee1f47512cc05a29";
    sha256 = "sha256-64z/xPzOPu5ow5dgKLPGY7D2P9fikhhSkXu3GPqr7WM=";
    finalImageTag = "6.0.4";
    arch = "amd64";
  };
in
{
  options = {
    server.media.radarr.enable = lib.mkEnableOption "radarr manifest on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.radarr.enable) {
    services.k3s = {
      images = [ image ];
      manifests.radarr.content = [
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "radarr-config";
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
            name = "radarr";
            namespace = "media";
          };
          spec = {
            replicas = 1;
            selector.matchLabels.app = "radarr";
            template = {
              metadata.labels.app = "radarr";
              spec = {
                securityContext = {
                  runAsUser = 1000;
                  runAsGroup = 1000;
                  fsGroup = 1000;
                };
                initContainers = [
                  {
                    name = "init-radarr";
                    image = "${image.imageName}:${image.imageTag}";
                    command = [
                      "sh"
                      "-c"
                      ''
                        set -e
                        mkdir -p /downloads/complete/radarr
                        mkdir -p /downloads/incomplete/radarr
                        mkdir -p /media/movies
                        echo "Radarr directories initialized"
                      ''
                    ];
                    securityContext = {
                      readOnlyRootFilesystem = true;
                      allowPrivilegeEscalation = false;
                      capabilities.drop = [ "ALL" ];
                    };
                    volumeMounts = [
                      {
                        name = "media";
                        mountPath = "/media";
                      }
                      {
                        name = "downloads";
                        mountPath = "/downloads";
                      }
                    ];
                  }
                ];
                containers = [
                  {
                    name = "radarr";
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
                      {
                        name = "DOTNET_SYSTEM_NET_DISABLEIPV6";
                        value = "1";
                      }
                      {
                        name = "DOTNET_SYSTEM_NET_FORCE_IPV4";
                        value = "1";
                      }
                    ];
                    ports = [ { containerPort = 7878; } ];
                    resources = {
                      requests.cpu = "500m";
                      requests.memory = "512Mi";
                      limits.cpu = "1000m";
                      limits.memory = "1Gi";
                    };
                    startupProbe = {
                      httpGet = {
                        path = "/";
                        port = 7878;
                      };
                      failureThreshold = 30;
                      periodSeconds = 5;
                    };
                    readinessProbe = {
                      httpGet = {
                        path = "/";
                        port = 7878;
                      };
                      initialDelaySeconds = 15;
                      periodSeconds = 10;
                      timeoutSeconds = 2;
                      failureThreshold = 3;
                    };
                    livenessProbe = {
                      httpGet = {
                        path = "/";
                        port = 7878;
                      };
                      initialDelaySeconds = 30;
                      periodSeconds = 20;
                      timeoutSeconds = 2;
                      failureThreshold = 3;
                    };
                    volumeMounts = [
                      {
                        name = "config";
                        mountPath = "/config";
                      }
                      {
                        name = "media";
                        mountPath = "/media";
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
                    persistentVolumeClaim.claimName = "radarr-config";
                  }
                  {
                    name = "media";
                    persistentVolumeClaim.claimName = "media";
                  }
                  {
                    name = "downloads";
                    persistentVolumeClaim.claimName = "downloads";
                  }
                ];
                dnsConfig.options = [
                  {
                    name = "ndots";
                    value = "1";
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
            name = "radarr-lb";
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
              "app" = "radarr";
            };
            ports = [
              {
                name = "http";
                port = 7878;
                targetPort = 7878;
                protocol = "TCP";
              }
            ];
          };
        }
      ];
    };
  };
}
