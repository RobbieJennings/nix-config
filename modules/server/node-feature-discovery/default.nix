{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.node-feature-discovery =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.node-feature-discovery-charts
        inputs.self.modules.nixos.node-feature-discovery-images
        inputs.self.modules.nixos.node-feature-discovery-settings
      ];

      options = {
        node-feature-discovery.enable = lib.mkEnableOption "Node feature discovery helm chart on k3s";
      };
    };
}
