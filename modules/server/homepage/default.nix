{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.homepage-images
        inputs.self.modules.nixos.homepage-namespace
        inputs.self.modules.nixos.homepage-deployment
        inputs.self.modules.nixos.homepage-homepage-settings
        inputs.self.modules.nixos.homepage-homepage-widgets
        inputs.self.modules.nixos.homepage-homepage-services
        inputs.self.modules.nixos.homepage-homepage-bookmarks
        inputs.self.modules.nixos.homepage-services
        inputs.self.modules.nixos.homepage-secrets
      ];

      options = {
        homepage.enable = lib.mkEnableOption "homepage helm chart on k3s";
        secrets.homepage.enable = lib.mkEnableOption "Homepage secrets";
      };
    };
}
