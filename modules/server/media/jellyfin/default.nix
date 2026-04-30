{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.jellyfin-images
        inputs.self.modules.nixos.jellyfin-persistence
        inputs.self.modules.nixos.jellyfin-deployment
        inputs.self.modules.nixos.jellyfin-services
      ];

      options = {
        media-server.jellyfin.enable = lib.mkEnableOption "Jellyfin deployment on k3s";
      };
    };
}
