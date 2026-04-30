{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.autoDeployCharts.grafana.values.persistence = {
          enabled = true;
          storageClassName = "longhorn";
          size = "10Gi";
        };
      };
    };
}
