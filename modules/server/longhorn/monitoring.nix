{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-monitoring =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.longhorn.enable {
        services.k3s.autoDeployCharts.longhorn.extraDeploy = [
          {
            apiVersion = "monitoring.coreos.com/v1";
            kind = "ServiceMonitor";
            metadata = {
              name = "longhorn-prometheus-servicemonitor";
              namespace = "monitoring";
              labels.release = "prometheus";
            };
            spec = {
              selector.matchLabels.app = "longhorn-manager";
              namespaceSelector.matchNames = [ "longhorn-system" ];
              endpoints = [
                { port = "manager"; }
              ];
            };
          }
        ];
      };
    };
}
