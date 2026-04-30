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
        version = "11.1.7";
        hash = "sha256-KSHxBROOLZeaf7CeqFm6mStp58AnRgQaclWRHyJL/FU=";
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
