{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.blog-deployment =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.blog.enable {
        services.k3s.manifests.blog.content = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "blog";
              namespace = "website";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "blog";
              template = {
                metadata.labels.app = "blog";
                spec = {
                  securityContext = {
                    runAsUser = 1000;
                    runAsGroup = 1000;
                    fsGroup = 1000;
                  };
                  containers = [
                    {
                      name = "blog";
                      image = "${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "blog"
                        ) null null config.services.k3s.images).imageName
                      }:${
                        (lib.lists.findSingle (
                          x: x ? imageName && x.imageName == "blog"
                        ) null null config.services.k3s.images).imageTag
                      }";
                      imagePullPolicy = "Never";
                      ports = [ { containerPort = 8080; } ];
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 8080;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8080;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 8080;
                        };
                        initialDelaySeconds = 30;
                        periodSeconds = 20;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      resources = config.server.resources.profiles.appMini;
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
