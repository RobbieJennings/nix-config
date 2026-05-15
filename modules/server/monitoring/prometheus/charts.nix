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
        version = "85.0.3";
        hash = "sha256-Cyoi+igMT57bxVumHwoEhXJ/eZpx0w53TMHzxPIdWAU=";
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
