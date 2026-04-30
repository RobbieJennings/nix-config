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
        version = "1.6.2";
        hash = "sha256-GE9XmX2Ks8nICygroipZw813Xq3GDWrL2bzMJ8GuOUc=";
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
