{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.alloy =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.alloy-charts
        inputs.self.modules.nixos.alloy-images
        inputs.self.modules.nixos.alloy-settings
        inputs.self.modules.nixos.alloy-services
      ];

      options = {
        monitoring.alloy.enable = lib.mkEnableOption "Alloy helm chart on k3s";
      };
    };
}
