{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.freshrss-namespace
        inputs.self.modules.nixos.freshrss-images
        inputs.self.modules.nixos.freshrss-deployment
        inputs.self.modules.nixos.freshrss-services
        inputs.self.modules.nixos.freshrss-persistence
        inputs.self.modules.nixos.freshrss-secrets
        inputs.self.modules.nixos.freshrss-cronjob
      ];

      options = {
        freshrss.enable = lib.mkEnableOption "FreshRSS deployment on k3s";
        secrets.freshrss.enable = lib.mkEnableOption "FreshRSS login secrets";
      };
    };
}
