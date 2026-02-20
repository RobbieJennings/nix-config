{
  inputs,
  ...
}:
{
  flake.modules.nixos.lidarr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      image = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/lidarr";
        imageDigest = "sha256:f2a186ce04ec5adb133f92a08dd3efbc918fc71b33077426ef099d94350dfa1b";
        sha256 = "sha256-IhX2Fp7rQ77jrIqefGvjFgD3huwhU3UshVQl3bbPu4c=";
        finalImageTag = "3.1.0";
        arch = "amd64";
      };
    in
    {
      options = {
        media-server.lidarr.enable = lib.mkEnableOption "lidarr manifest on k3s";
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.lidarr.enable) {
        services.k3s = {
          images = [ image ];
          manifests.lidarr.content = [
            {
              apiVersion = "v1";
              kind = "PersistentVolumeClaim";
              metadata = {
                name = "lidarr-config";
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
                name = "lidarr";
                namespace = "media";
              };
              spec = {
                replicas = 1;
                selector.matchLabels.app = "lidarr";
                template = {
                  metadata.labels.app = "lidarr";
                  spec = {
                    securityContext = {
                      runAsUser = 1000;
                      runAsGroup = 1000;
                      fsGroup = 1000;
                    };
                    initContainers = [
                      {
                        name = "init-lidarr";
                        image = "${image.imageName}:${image.imageTag}";
                        command = [
                          "sh"
                          "-c"
                          ''
                            set -e
                            mkdir -p /downloads/complete/lidarr
                            mkdir -p /downloads/incomplete/lidarr
                            mkdir -p /media/music
                            echo "Lidarr directories initialized"
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
                        name = "lidarr";
                        image = "${image.imageName}:${image.imageTag}";
                        ports = [ { containerPort = 8686; } ];
                        resources = {
                          requests.cpu = "1000m";
                          requests.memory = "1Gi";
                          limits.cpu = "2000m";
                          limits.memory = "2Gi";
                        };
                        startupProbe = {
                          httpGet = {
                            path = "/";
                            port = 8686;
                          };
                          failureThreshold = 30;
                          periodSeconds = 5;
                        };
                        readinessProbe = {
                          httpGet = {
                            path = "/";
                            port = 8686;
                          };
                          initialDelaySeconds = 15;
                          periodSeconds = 10;
                          timeoutSeconds = 2;
                          failureThreshold = 3;
                        };
                        livenessProbe = {
                          httpGet = {
                            path = "/";
                            port = 8686;
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
                        persistentVolumeClaim.claimName = "lidarr-config";
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
                        value = "0";
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
                name = "lidarr-lb";
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
                  "app" = "lidarr";
                };
                ports = [
                  {
                    name = "http";
                    port = 8686;
                    targetPort = 8686;
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
