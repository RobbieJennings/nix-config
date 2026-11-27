{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prowlarr-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.media-server.prowlarr = {
        resources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appSmall;
          description = "Resource profile for Prowlarr";
        };
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.prowlarr.enable) {
        services.k3s.manifests.prowlarr.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "prowlarr";
              namespace = "media";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "prowlarr";
              template = {
                metadata.labels.app = "prowlarr";
                spec = {
                  containers = [
                    {
                      name = "prowlarr";
                      image = "${config._module.args.prowlarrImages.prowlarrImage.imageName}:${config._module.args.prowlarrImages.prowlarrImage.imageTag}";
                      ports = [ { containerPort = 9696; } ];
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
                      resources = config.media-server.prowlarr.resources;
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 9696;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 9696;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 9696;
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
                      ];
                    }
                  ];
                  volumes = [
                    {
                      name = "config";
                      persistentVolumeClaim.claimName = "prowlarr-pvc";
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
