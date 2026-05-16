{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      grafanaChart = {
        name = "grafana";
        repo = "https://grafana-community.github.io/helm-charts";
        version = "12.3.3";
        hash = "sha256-4vAczu8h+9q5DFRRSmNcEElPQ3ZS+YxHXv7lcSLtNJE=";
      };
    in
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.autoDeployCharts = {
          grafana = grafanaChart // {
            targetNamespace = "monitoring";
            createNamespace = true;
          };
        };
      };
    };
}
