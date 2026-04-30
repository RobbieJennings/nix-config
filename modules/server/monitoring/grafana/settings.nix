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
          resources = {
            requests.cpu = "50m";
            requests.memory = "128Mi";
            limits.cpu = "300m";
            limits.memory = "256Mi";
          };
          datasources = {
            "datasources.yaml" = {
              apiVersion = 1;
              datasources = [
                {
                  name = "Prometheus";
                  type = "prometheus";
                  access = "proxy";
                  url = "http://192.168.1.210:9090";
                  isDefault = true;
                  editable = false;
                }
                {
                  name = "Loki";
                  type = "loki";
                  access = "proxy";
                  url = "http://192.168.1.210:3100";
                  editable = false;
                }
              ];
            };
          };
        };
      };
    };
}
