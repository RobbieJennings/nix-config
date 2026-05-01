{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.radarr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.radarr-images
        inputs.self.modules.nixos.radarr-persistence
        inputs.self.modules.nixos.radarr-deployment
        inputs.self.modules.nixos.radarr-services
      ];

      options = {
        media-server.radarr.enable = lib.mkEnableOption "Radarr deployment on k3s";
      };
    };
}
