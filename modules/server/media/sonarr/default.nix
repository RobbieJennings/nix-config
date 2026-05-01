{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.sonarr-images
        inputs.self.modules.nixos.sonarr-persistence
        inputs.self.modules.nixos.sonarr-deployment
        inputs.self.modules.nixos.sonarr-services
      ];

      options = {
        media-server.sonarr.enable = lib.mkEnableOption "Sonarr deployment on k3s";
      };
    };
}
