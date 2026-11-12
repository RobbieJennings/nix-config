{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.calibre-web-automated-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.calibre-web-automated.enable) {
        services.k3s.manifests.calibre-web-automated.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "calibre-web-automated";
              namespace = "media";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "calibre-web-automated";
              template = {
                metadata.labels.app = "calibre-web-automated";
                spec = {
                  initContainers = [
                    {
                      name = "init-calibre-web-automated";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "crocodilestick/calibre-web-automated" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      command = [
                        "sh"
                        "-c"
                        ''
                          set -e
                          mkdir -p /media/books
                          mkdir -p /media/books/ingest
                          mkdir -p /config/.cwa_conversion_tmp
                          echo "Calibre-Web-Automated directories initialized"
                        ''
                      ];
                      securityContext = {
                        fsGroup = 1000;
                        runAsUser = 1000;
                        runAsGroup = 1000;
                        readOnlyRootFilesystem = true;
                        allowPrivilegeEscalation = false;
                        capabilities.drop = [ "ALL" ];
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
                      ];
                    }
                  ];
                  containers = [
                    {
                      name = "calibre-web-automated";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "crocodilestick/calibre-web-automated" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      ports = [ { containerPort = 8083; } ];
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
                          port = 8083;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8083;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8083;
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
                          mountPath = "/cwa-book-ingest";
                          subPath = "books/ingest";
                        }
                        {
                          name = "media";
                          mountPath = "/calibre-library";
                          subPath = "books/books";
                        }
                      ];
                    }
                  ];
                  volumes = [
                    {
                      name = "config";
                      persistentVolumeClaim.claimName = "calibre-web-automated-pvc";
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
