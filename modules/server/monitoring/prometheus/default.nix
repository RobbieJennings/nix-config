{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.prometheus-charts
        inputs.self.modules.nixos.prometheus-images
        inputs.self.modules.nixos.prometheus-settings
        inputs.self.modules.nixos.prometheus-services
      ];

      options = {
        monitoring.prometheus.enable = lib.mkEnableOption "Prometheus helm chart on k3s";
      };
    };
}
