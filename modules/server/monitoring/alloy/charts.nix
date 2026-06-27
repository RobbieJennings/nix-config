{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.alloy-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      alloyChart = {
        name = "alloy";
        repo = "https://grafana.github.io/helm-charts";
        version = "1.10.0";
        hash = "sha256-q8ceioRgZbSPD5g73De4nEZWkPF5fD3zFN7kxQGdtdU=";
      };
    in
    {
      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s.autoDeployCharts = {
          alloy = alloyChart // {
            targetNamespace = "monitoring";
            createNamespace = true;
          };
        };
      };
    };
}
