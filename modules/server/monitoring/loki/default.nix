{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.loki =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.loki-charts
        inputs.self.modules.nixos.loki-images
        inputs.self.modules.nixos.loki-settings
        inputs.self.modules.nixos.loki-services
        inputs.self.modules.nixos.loki-persistence
        inputs.self.modules.nixos.loki-secrets
      ];

      options = {
        monitoring.loki.enable = lib.mkEnableOption "Loki helm chart on k3s";
        secrets.loki.enable = lib.mkEnableOption "Loki secrets";
      };
    };
}
