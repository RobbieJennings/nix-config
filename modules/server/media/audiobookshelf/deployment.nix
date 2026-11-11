{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.audiobookshelf-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.audiobookshelf.enable) {
        services.k3s.manifests.audiobookshelf.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "audiobookshelf";
              namespace = "media";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "audiobookshelf";
              template = {
                metadata.labels.app = "audiobookshelf";
                spec = {
                  securityContext = {
                    fsGroup = 1000;
                    runAsUser = 1000;
                    runAsGroup = 1000;
                  };
                  initContainers = [
                    {
                      name = "init-audiobookshelf";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "ghcr.io/advplyr/audiobookshelf" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      command = [
                        "sh"
                        "-c"
                        ''
                          set -e
                          mkdir -p /media/audiobooks/audiobooks
                          mkdir -p /media/audiobooks/podcasts
                          mkdir -p /media/audiobooks/metadata
                          echo "Audiobookshelf directories initialized"
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
                      ];
                    }
                  ];
                  containers = [
                    {
                      name = "audiobookshelf";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "ghcr.io/advplyr/audiobookshelf" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      ports = [ { containerPort = 80; } ];
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
                      resources = config.server.resources.profiles.appSmall;
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 80;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 80;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 80;
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
                          mountPath = "/audiobooks";
                          subPath = "audiobooks/audiobooks";
                        }
                        {
                          name = "media";
                          mountPath = "/podcasts";
                          subPath = "audiobooks/podcasts";
                        }
                        {
                          name = "media";
                          mountPath = "/metadata";
                          subPath = "audiobooks/metadata";
                        }
                      ];
                    }
                  ];
                  volumes = [
                    {
                      name = "config";
                      persistentVolumeClaim.claimName = "audiobookshelf-pvc";
                    }
                    {
                      name = "media";
                      persistentVolumeClaim.claimName = "media-pvc";
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
