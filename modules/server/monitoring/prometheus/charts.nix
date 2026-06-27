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
        version = "87.3.0";
        hash = "sha256-jkXY4SrSBLzTRQlYuOgFghFo06OKfd3Um292O3pTuKA=";
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
