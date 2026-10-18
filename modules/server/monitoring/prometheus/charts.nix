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
        version = "92.10.1";
        hash = "sha256-DRbETpQTckAO6LzcIy6+6Vfu/MkQ+IM3Z9i5QUXyAJQ=";
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
