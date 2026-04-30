{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.cert-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.cert-manager-charts
        inputs.self.modules.nixos.cert-manager-images
        inputs.self.modules.nixos.cert-manager-settings
      ];

      options = {
        cert-manager.enable = lib.mkEnableOption "Cert-manager helm chart on k3s";
      };
    };
}
