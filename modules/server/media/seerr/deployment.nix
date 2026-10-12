{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.seerr-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.seerr.enable) {
        services.k3s.manifests.seerr.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "seerr";
              namespace = "media";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "seerr";
              template = {
                metadata.labels.app = "seerr";
                spec = {
                  securityContext = {
                    fsGroup = 1000;
                    runAsUser = 1000;
                    runAsGroup = 1000;
                  };
                  containers = [
                    {
                      name = "seerr";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "ghcr.io/seerr-team/seerr" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      ports = [ { containerPort = 5055; } ];
                      env = [
                        {
                          name = "TZ";
                          value = "Europe/Dublin";
                        }
                      ];
                      resources = config.server.resources.profiles.appSmall;
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 5055;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 5055;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 5055;
                        };
                        initialDelaySeconds = 30;
                        periodSeconds = 20;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      volumeMounts = [
                        {
                          name = "config";
                          mountPath = "/app/config";
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
                      persistentVolumeClaim.claimName = "seerr-pvc";
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
