{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.freshrss.enable {
        services.k3s.manifests.freshrss.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "freshrss";
              namespace = "freshrss";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "freshrss";
              template = {
                metadata.labels.app = "freshrss";
                spec = {
                  containers = [
                    {
                      name = "freshrss";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "linuxserver/freshrss" config.services.k3s.images;
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
                        {
                          name = "TZ";
                          value = "UTC";
                        }
                      ];
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
                      resources = config.server.resources.profiles.appSmall;
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
                      persistentVolumeClaim.claimName = "freshrss-pvc";
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
