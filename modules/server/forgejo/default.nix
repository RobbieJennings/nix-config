{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.forgejo-charts
        inputs.self.modules.nixos.forgejo-images
        inputs.self.modules.nixos.forgejo-settings
        inputs.self.modules.nixos.forgejo-postgres
        inputs.self.modules.nixos.forgejo-valkey
        inputs.self.modules.nixos.forgejo-services
        inputs.self.modules.nixos.forgejo-persistence
        inputs.self.modules.nixos.forgejo-secrets
      ];

      options = {
        forgejo.enable = lib.mkEnableOption "forgejo helm chart on k3s";
        secrets.forgejo.enable = lib.mkEnableOption "Forgejo secrets";
      };
    };
}
