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
                    url = "http://192.168.1.210:3100/loki/api/v1/push"
                  }
                }
              '';
            };
          };
          resources = {
            requests.cpu = "20m";
            requests.memory = "64Mi";
            limits.cpu = "200m";
            limits.memory = "256Mi";
          };
        };
      };
    };
}
