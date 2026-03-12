{
  inputs,
  ...
}:
{
  flake.modules.nixos.monitoring =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.prometheus
        inputs.self.modules.nixos.loki
        inputs.self.modules.nixos.alloy
        inputs.self.modules.nixos.grafana
      ];

      options = {
        monitoring.enable = lib.mkEnableOption "prometheus, grafana and loki services on k3s";
      };

      config = lib.mkIf config.monitoring.enable {
        monitoring = {
          prometheus.enable = lib.mkDefault true;
          loki.enable = lib.mkDefault true;
          alloy.enable = lib.mkDefault true;
          grafana.enable = lib.mkDefault true;
        };
      };
    };
}
