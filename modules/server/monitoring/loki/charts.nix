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
        version = "17.1.6";
        hash = "sha256-XszR7HPqtXitY4iM4ZoWBhkrOUhUq2MUm67yybMYbGg=";
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
