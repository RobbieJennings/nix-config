{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.lidarr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.lidarr-images
        inputs.self.modules.nixos.lidarr-persistence
        inputs.self.modules.nixos.lidarr-deployment
        inputs.self.modules.nixos.lidarr-services
      ];

      options = {
        media-server.lidarr.enable = lib.mkEnableOption "Lidarr deployment on k3s";
      };
    };
}
