{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.netbird-operator-charts
        inputs.self.modules.nixos.netbird-operator-images
        inputs.self.modules.nixos.netbird-operator-settings
        inputs.self.modules.nixos.netbird-operator-secrets
        inputs.self.modules.nixos.netbird-operator-router
      ];

      options = {
        netbird-operator.enable = lib.mkEnableOption "Netbird operator helm chart on k3s";
        secrets.netbird-operator.enable = lib.mkEnableOption "SOPS-managed OAuth secret for Netbird operator";
      };
    };
}
