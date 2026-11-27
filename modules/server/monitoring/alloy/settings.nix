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
      options.monitoring.alloy = {
        resources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.appMini;
          description = "Resource profile for Alloy";
        };
      };

      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s.autoDeployCharts.alloy.values = {
          image = {
            repository = config._module.args.alloyImages.alloyImage.imageName;
            tag = config._module.args.alloyImages.alloyImage.imageTag;
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
                discovery.relabel "pods" {
                  targets = discovery.kubernetes.pods.targets
                  rule {
                    source_labels = ["__meta_kubernetes_namespace"]
                    target_label  = "namespace"
                  }
                  rule {
                    source_labels = ["__meta_kubernetes_pod_name"]
                    target_label  = "pod"
                  }
                  rule {
                    source_labels = ["__meta_kubernetes_pod_container_name"]
                    target_label  = "container"
                  }
                }
                loki.source.kubernetes "pods" {
                  targets = discovery.relabel.pods.output
                  forward_to = [loki.write.default.receiver]
                }
                loki.write "default" {
                  endpoint {
                    url = "http://loki:3100/loki/api/v1/push"
                  }
                }
              '';
            };
            resources = config.monitoring.alloy.resources;
          };
        };
      };
    };
}
