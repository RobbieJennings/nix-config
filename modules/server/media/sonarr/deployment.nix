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
      options.media-server.sonarr = {
        resources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appSmall;
          description = "Resource profile for Sonarr";
        };
      };

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
                      image = "${config._module.args.sonarrImages.sonarrImage.imageName}:${config._module.args.sonarrImages.sonarrImage.imageTag}";
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
                      image = "${config._module.args.sonarrImages.sonarrImage.imageName}:${config._module.args.sonarrImages.sonarrImage.imageTag}";
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
                      resources = config.media-server.sonarr.resources;
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
                      persistentVolumeClaim.claimName = "sonarr-pvc";
                    }
                    {
                      name = "media";
                      persistentVolumeClaim.claimName = "media-pvc";
                    }
                    {
                      name = "downloads";
                      persistentVolumeClaim.claimName = "downloads-pvc";
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
