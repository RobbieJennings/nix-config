{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.flaresolverr-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.flaresolverr.enable) {
        services.k3s.manifests.flaresolverr.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "flaresolverr";
              namespace = "media";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "flaresolverr";
              template = {
                metadata.labels.app = "flaresolverr";
                spec = {
                  securityContext = {
                    runAsUser = 1000;
                    runAsGroup = 1000;
                    fsGroup = 1000;
                  };
                  containers = [
                    {
                      name = "flaresolverr";
                      image = "${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "flaresolverr/flaresolverr"
                        ) null null config.services.k3s.images).imageName
                      }:${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "flaresolverr/flaresolverr"
                        ) null null config.services.k3s.images).imageTag
                      }";
                      env = [
                        {
                          name = "LOG_LEVEL";
                          value = "info";
                        }
                        {
                          name = "TZ";
                          value = "UTC";
                        }
                      ];
                      ports = [ { containerPort = 8191; } ];
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 8191;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8191;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8191;
                        };
                        initialDelaySeconds = 30;
                        periodSeconds = 20;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      resources = {
                        requests.cpu = "100m";
                        requests.memory = "256Mi";
                        limits.cpu = "500m";
                        limits.memory = "512Mi";
                      };
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
