{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  image = pkgs.dockerTools.pullImage {
    imageName = "linuxserver/sonarr";
    imageDigest = "sha256:4b8a853b76337cd5de5f69961e23b7d0792ce7bf0a8be083dd7202ef670bfc34";
    sha256 = "sha256-/wqQhgSMQ8fHwjNS+8n4VtWi/2bREJAPbCaIqeJKMDw=";
    finalImageTag = "4.0.16";
    arch = "amd64";
  };
in
{
  options = {
    server.media.sonarr.enable = lib.mkEnableOption "sonarr manifest on k3s";
  };

  config = lib.mkIf (config.server.media.enable && config.server.media.sonarr.enable) {
    services.k3s = {
      images = [ image ];
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
          apiVersion = "batch/v1";
          kind = "Job";
          metadata = {
            name = "sonarr-init-dirs";
            namespace = "media";
          };
          spec = {
            template = {
              spec = {
                restartPolicy = "OnFailure";
                securityContext = {
                  runAsUser = 1000;
                  runAsGroup = 1000;
                  fsGroup = 1000;
                };
                containers = [
                  {
                    name = "init-dirs";
                    image = "busybox:latest";
                    command = [
                      "sh"
                      "-c"
                      ''
                        mkdir -p /downloads/complete/sonarr
                        mkdir -p /downloads/incomplete/sonarr
                        mkdir -p /media/shows
                        echo "Directories created successfully"
                      ''
                    ];
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
                volumes = [
                  {
                    name = "media";
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
                securityContext = {
                  runAsUser = 1000;
                  runAsGroup = 1000;
                  fsGroup = 1000;
                };
                containers = [
                  {
                    name = "sonarr";
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
                    ports = [ { containerPort = 8989; } ];
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
                    persistentVolumeClaim.claimName = "sonarr-config";
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
              "metallb.io/allow-shared-ip" = "media";
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
