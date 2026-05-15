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
        version = "14.2.0";
        hash = "sha256-YCVdnRfOgIwTHAUciyudeZISEH3YVJ9RN6ndqQcl3OY=";
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
