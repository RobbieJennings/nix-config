{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.immich-charts
        inputs.self.modules.nixos.immich-images
        inputs.self.modules.nixos.immich-settings
        inputs.self.modules.nixos.immich-postgres
        inputs.self.modules.nixos.immich-valkey
        inputs.self.modules.nixos.immich-services
        inputs.self.modules.nixos.immich-persistence
        inputs.self.modules.nixos.immich-secrets
      ];

      options = {
        immich.enable = lib.mkEnableOption "Immich helm chart on k3s";
        secrets.immich.enable = lib.mkEnableOption "Immich secrets";
      };

      config = lib.mkIf config.immich.enable {
        immich-valkey.enable = true;
      };
    };
}
