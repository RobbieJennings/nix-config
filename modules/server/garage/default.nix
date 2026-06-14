{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.garage-charts
        inputs.self.modules.nixos.garage-images
        inputs.self.modules.nixos.garage-settings
        inputs.self.modules.nixos.garage-services
        inputs.self.modules.nixos.garage-persistence
        inputs.self.modules.nixos.garage-web-ui
        inputs.self.modules.nixos.garage-secrets
      ];

      options = {
        garage.enable = lib.mkEnableOption "garage helm chart on k3s";
        secrets.garage.enable = lib.mkEnableOption "garage secrets";
      };
    };
}
