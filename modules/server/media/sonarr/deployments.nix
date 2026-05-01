{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.sonarr.enable) {
        services.k3s.manifests.sonarr.content = [
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
                    fsGroup = 1000;
                    runAsUser = 1000;
                    runAsGroup = 1000;
                  };
                  initContainers = [
                    {
                      name = "init-sonarr";
                      image = "${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/sonarr"
                        ) null null config.services.k3s.images).imageName
                      }:${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/sonarr"
                        ) null null config.services.k3s.images).imageTag
                      }";
                      command = [
                        "sh"
                        "-c"
                        ''
                          set -e
                          mkdir -p /downloads/complete/sonarr
                          mkdir -p /downloads/incomplete/sonarr
                          mkdir -p /media/shows
                          echo "Sonarr directories initialized"
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
                      name = "sonarr";
                      image = "${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/sonarr"
                        ) null null config.services.k3s.images).imageName
                      }:${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "linuxserver/sonarr"
                        ) null null config.services.k3s.images).imageTag
                      }";
                      ports = [ { containerPort = 8989; } ];
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
                      resources = {
                        requests.cpu = "100m";
                        requests.memory = "256Mi";
                        limits.cpu = "500m";
                        limits.memory = "512Mi";
                      };
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 8989;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8989;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8989;
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
        ];
      };
    };
}
