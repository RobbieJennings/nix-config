{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.shelfmark-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.shelfmark.enable) {
        services.k3s.manifests.shelfmark.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "shelfmark";
              namespace = "media";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "shelfmark";
              template = {
                metadata.labels.app = "shelfmark";
                spec = {
                  securityContext = {
                    fsGroup = 1000;
                    runAsUser = 1000;
                    runAsGroup = 1000;
                  };
                  initContainers = [
                    {
                      name = "init-shelfmark";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "ghcr.io/calibrain/shelfmark" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      command = [
                        "sh"
                        "-c"
                        ''
                          set -e
                          mkdir -p /media/books/ingest
                          mkdir -p /media/audiobooks/audiobooks
                          echo "Shelfmark directories initialized"
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
                      name = "shelfmark";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "ghcr.io/calibrain/shelfmark" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      ports = [ { containerPort = 8084; } ];
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
                      resources = config.server.resources.profiles.appLarge;
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 8084;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8084;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8084;
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
                      persistentVolumeClaim.claimName = "shelfmark-pvc";
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
