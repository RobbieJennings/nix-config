{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-valkey =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.forgejo = {
        valkeyResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.cache;
          description = "Resource profile for Forgejo's cache";
        };
        redisExporterResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraSmall;
          description = "Resource profile for Forgejo's cache metrics exporter";
        };
      };

      config = lib.mkIf config.forgejo.enable {
        services.k3s.autoDeployCharts.forgejo.extraDeploy = [
          {
            apiVersion = "valkey.io/v1alpha1";
            kind = "ValkeyCluster";
            metadata = {
              namespace = "forgejo";
              name = "forgejo-valkey";
            };
            spec = {
              image = "${config._module.args.valkeyImages.valkeyImage.imageName}:${config._module.args.valkeyImages.valkeyImage.imageTag}";
              shards = 1;
              replicas = 0;
              users = [
                {
                  name = "forgejo";
                  permissions = "+@all ~* &*";
                  passwordSecret = {
                    name = "forgejo-secrets";
                    keys = [ "valkey-password" ];
                  };
                }
              ];
              resources = config.forgejo.valkeyResources;
              exporter = {
                enabled = true;
                image = "${config._module.args.valkeyImages.exporterImage.imageName}:${config._module.args.valkeyImages.exporterImage.imageTag}";
                resources = config.forgejo.redisExporterResources;
              };
            };
          }
          {
            apiVersion = "monitoring.coreos.com/v1";
            kind = "PodMonitor";
            metadata = {
              name = "forgejo-valkey-prometheus-podmonitor";
              namespace = "monitoring";
              labels.release = "prometheus";
            };
            spec = {
              selector.matchLabels = {
                "app.kubernetes.io/instance" = "forgejo-valkey-0-0";
                "app.kubernetes.io/component" = "valkey-node";
              };
              namespaceSelector.matchNames = [ "forgejo" ];
              podMetricsEndpoints = [
                { port = "metrics"; }
              ];
            };
          }
        ];
      };
    };
}
