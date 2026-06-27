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
        version = "12.7.1";
        hash = "sha256-5uMKeXg/0JE9Ir6r+u50Dhjtv/cYb32f7ARR7qQGoHo=";
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
