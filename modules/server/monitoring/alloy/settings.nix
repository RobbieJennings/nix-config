{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.alloy-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s.autoDeployCharts.alloy.values = {
          image =
            let
              image = inputs.self.lib.findImageByName "grafana/alloy" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
            };
          service.enabled = false;
          alloy = {
            configMap = {
              create = true;
              content = ''
                logging {
                  level = "info"
                }
                discovery.kubernetes "pods" {
                  role = "pod"
                }
                loki.source.kubernetes "pods" {
                  targets = discovery.kubernetes.pods.targets
                  forward_to = [loki.write.default.receiver]
                }
                loki.write "default" {
                  endpoint {
                    url = "http://loki:3100/loki/api/v1/push"
                  }
                }
              '';
            };
          };
          resources = config.server.resources.profiles.appMini;
        };
      };
    };
}
