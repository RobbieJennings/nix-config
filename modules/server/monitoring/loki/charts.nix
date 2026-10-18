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
        version = "18.17.1";
        hash = "sha256-N/mSdPZx89YC7bSQyvAoETDh0UqJYizLthps8Brwmws=";
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
