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
        version = "1.13.1";
        hash = "sha256-bCt98j45Q4uxHx4fzxnrnrfIv+q31Jt8l1tiEqvQ+Zo=";
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
