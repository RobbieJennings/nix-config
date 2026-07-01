{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.autoDeployCharts.grafana.values = {
          image =
            let
              image = inputs.self.lib.findImageByName "grafana/grafana" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
            };
          replicas = 1;
          adminUser = "admin";
          adminPassword = "changeme";
          admin =
            if (config.secrets.enable && config.secrets.grafana.enable) then
              {
                existingSecret = "grafana-secrets";
              }
            else
              { };
          persistence = {
            enabled = true;
            existingClaim = "grafana-pvc";
          };
          service.enabled = false;
          resources = config.server.resources.profiles.appMedium;
          datasources = {
            "datasources.yaml" = {
              apiVersion = 1;
              datasources = [
                {
                  name = "Prometheus";
                  type = "prometheus";
                  access = "proxy";
                  url = "http://prometheus-operated:9090";
                  isDefault = true;
                  editable = false;
                }
                {
                  name = "Loki";
                  type = "loki";
                  access = "proxy";
                  url = "http://loki:3100";
                  editable = false;
                }
              ];
            };
          };
        };
      };
    };
}
