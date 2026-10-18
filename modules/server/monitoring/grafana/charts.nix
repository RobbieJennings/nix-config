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
        version = "14.0.1";
        hash = "sha256-Tbxu1o7innjt1NtH0Qqtcvj8Rz5BaVAaK9rxSUY+dN8=";
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
