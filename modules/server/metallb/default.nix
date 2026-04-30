{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.metallb =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.metallb-charts
        inputs.self.modules.nixos.metallb-images
        inputs.self.modules.nixos.metallb-settings
      ];

      options = {
        metallb.enable = lib.mkEnableOption "Metallb helm chart on k3s";
      };
    };
}
