{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage-web-ui =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.garage.enable {
        services.k3s.autoDeployCharts.garage.extraDeploy = [
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "garage-web-ui";
              namespace = "garage";
            };
            spec = {
              replicas = 1;
              selector.matchLabels.app = "garage-web-ui";
              template = {
                metadata.labels.app = "garage-web-ui";
                spec = {
                  containers = [
                    {
                      name = "garage-web-ui";
                      image =
                        let
                          image = inputs.self.lib.findImageByName "khairul169/garage-webui" config.services.k3s.images;
                        in
                        "${image.imageName}:${image.imageTag}";
                      ports = [ { containerPort = 3909; } ];
                      env = [
                        {
                          name = "API_BASE_URL";
                          value = "http://garage-lb.garage.svc.cluster.local:3903";
                        }
                        {
                          name = "API_ADMIN_KEY";
                          valueFrom.secretKeyRef = {
                            name = "garage-web-ui-secrets";
                            key = "API_ADMIN_KEY";
                          };
                        }
                      ];
                      resources = config.server.resources.profiles.appSmall;
                      startupProbe = {
                        httpGet = {
                          path = "/";
                          port = 3909;
                        };
                        failureThreshold = 30;
                        periodSeconds = 5;
                      };
                      readinessProbe = {
                        httpGet = {
                          path = "/";
                          port = 3909;
                        };
                        initialDelaySeconds = 15;
                        periodSeconds = 10;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
                      livenessProbe = {
                        httpGet = {
                          path = "/";
                          port = 3909;
                        };
                        initialDelaySeconds = 30;
                        periodSeconds = 20;
                        timeoutSeconds = 2;
                        failureThreshold = 3;
                      };
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
