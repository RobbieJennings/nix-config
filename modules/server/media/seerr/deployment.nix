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
      options.media-server.seerr = {
        resources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appSmall;
          description = "Resource profile for Seerr";
        };
      };

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
                      image = "${config._module.args.seerrImages.seerrImage.imageName}:${config._module.args.seerrImages.seerrImage.imageTag}";
                      ports = [ { containerPort = 5055; } ];
                      resources = config.media-server.seerr.resources;
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
                      ];
                    }
                  ];
                  volumes = [
                    {
                      name = "config";
                      persistentVolumeClaim.claimName = "seerr-pvc";
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
