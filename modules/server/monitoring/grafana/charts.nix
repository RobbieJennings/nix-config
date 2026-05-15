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
        version = "12.3.2";
        hash = "sha256-Rp6rDIY61WdA3EoN9EZkHXersKv1R1JowZe+0kW73kM=";
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
