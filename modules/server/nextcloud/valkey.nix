{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-valkey =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.nextcloud = {
        valkeyResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.cache;
          description = "Resource profile for Nextcloud's cache";
        };
        redisExporterResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraSmall;
          description = "Resource profile for Nextcloud's cache metrics exporter";
        };
      };
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts.nextcloud.extraDeploy = [
          {
            apiVersion = "valkey.io/v1alpha1";
            kind = "ValkeyCluster";
            metadata = {
              namespace = "nextcloud";
              name = "nextcloud-valkey";
            };
            spec = {
              image = "${config._module.args.valkeyImages.valkeyImage.imageName}:${config._module.args.valkeyImages.valkeyImage.imageTag}";
              shards = 1;
              replicas = 0;
              users = [
                {
                  name = "nextcloud";
                  permissions = "+@all ~* &*";
                  passwordSecret = {
                    name = "nextcloud-secrets";
                    keys = [ "valkey-password" ];
                  };
                }
              ];
              resources = config.nextcloud.valkeyResources;
              exporter = {
                enabled = true;
                image = "${config._module.args.valkeyImages.exporterImage.imageName}:${config._module.args.valkeyImages.exporterImage.imageTag}";
                resources = config.nextcloud.redisExporterResources;
              };
            };
          }
          {
            apiVersion = "monitoring.coreos.com/v1";
            kind = "PodMonitor";
            metadata = {
              name = "nextcloud-valkey-prometheus-podmonitor";
              namespace = "monitoring";
              labels.release = "prometheus";
            };
            spec = {
              selector.matchLabels = {
                "app.kubernetes.io/instance" = "nextcloud-valkey-0-0";
                "app.kubernetes.io/component" = "valkey-node";
              };
              namespaceSelector.matchNames = [ "nextcloud" ];
              podMetricsEndpoints = [
                { port = "metrics"; }
              ];
            };
          }
        ];
      };
    };
}
