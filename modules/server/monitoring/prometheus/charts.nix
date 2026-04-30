{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      prometheusChart = {
        name = "kube-prometheus-stack";
        repo = "https://prometheus-community.github.io/helm-charts";
        version = "82.2.0";
        hash = "sha256-/HnGrYhMeKjzSrEl+ZZjfGjTJkzzSkXVdb1u+3h9FPA=";
      };
    in
    {
      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s.autoDeployCharts = {
          prometheus = prometheusChart // {
            targetNamespace = "monitoring";
            createNamespace = true;
          };
        };
      };
    };
}
