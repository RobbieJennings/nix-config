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
        version = "1.8.1";
        hash = "sha256-vnsAFSgE8HzdrYseH1w7mHQhrZG/gueov66Kt32WMnM=";
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
