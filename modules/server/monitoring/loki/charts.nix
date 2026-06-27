{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.loki-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      lokiChart = {
        name = "loki";
        repo = "https://grafana-community.github.io/helm-charts";
        version = "18.1.1";
        hash = "sha256-btaT1OqsnS0MlGr7Cp5QhzYfg33ksLRcikpHHtZpQc4=";
      };
    in
    {
      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s.autoDeployCharts = {
          loki = lokiChart // {
            targetNamespace = "monitoring";
            createNamespace = true;
          };
        };
      };
    };
}
