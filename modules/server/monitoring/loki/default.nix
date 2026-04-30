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
      ];

      options = {
        monitoring.loki.enable = lib.mkEnableOption "Loki helm chart on k3s";
      };
    };
}
