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
              image =
                let
                  image = inputs.self.lib.findImageByName "valkey/valkey" config.services.k3s.images;
                in
                "${image.imageName}:${image.imageTag}";
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
              resources = config.server.resources.profiles.cache;
              exporter = {
                enabled = true;
                image =
                  let
                    image = inputs.self.lib.findImageByName "oliver006/redis_exporter" config.services.k3s.images;
                  in
                  "${image.imageName}:${image.imageTag}";
                resources = config.server.resources.profiles.infraSmall;
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
