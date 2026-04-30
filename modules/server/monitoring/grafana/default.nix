{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.grafana-charts
        inputs.self.modules.nixos.grafana-images
        inputs.self.modules.nixos.grafana-settings
        inputs.self.modules.nixos.grafana-services
        inputs.self.modules.nixos.grafana-persistence
        inputs.self.modules.nixos.grafana-secrets
      ];

      options = {
        monitoring.grafana.enable = lib.mkEnableOption "Grafana helm chart on k3s";
        secrets.grafana.enable = lib.mkEnableOption "Grafana secrets";
      };
    };
}
