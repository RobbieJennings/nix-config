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
      options.blog = {
        resources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appMini;
          description = "Resource profile for Blog";
        };
      };

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
                      image = "${config._module.args.blogImages.blogImage.imageName}:${config._module.args.blogImages.blogImage.imageTag}";
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
                      resources = config.blog.resources;
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
