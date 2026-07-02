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
              image =
                let
                  image = inputs.self.lib.findImageByName "valkey/valkey" config.services.k3s.images;
                in
                "${image.imageName}:${image.imageTag}";
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
