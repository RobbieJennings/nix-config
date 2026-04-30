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
        repo = "https://grafana.github.io/helm-charts";
        version = "6.53.0";
        hash = "sha256-Op38u8XMpiwakIeT6a4+/Uzn78mSSCM6co3HCrrZSM4=";
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
