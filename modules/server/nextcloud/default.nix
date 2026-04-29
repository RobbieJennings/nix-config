{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.nextcloud-charts
        inputs.self.modules.nixos.nextcloud-images
        inputs.self.modules.nixos.nextcloud-settings
        inputs.self.modules.nixos.nextcloud-postgres
        inputs.self.modules.nixos.nextcloud-valkey
        inputs.self.modules.nixos.nextcloud-services
        inputs.self.modules.nixos.nextcloud-persistence
        inputs.self.modules.nixos.nextcloud-secrets
      ];

      options = {
        nextcloud.enable = lib.mkEnableOption "nextcloud helm chart on k3s";
        secrets.nextcloud.enable = lib.mkEnableOption "Nextcloud secrets";
      };

      config = lib.mkIf config.nextcloud.enable {
        nextcloud-valkey.enable = true;
      };
    };
}
