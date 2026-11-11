{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.audiobookshelf =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.audiobookshelf-images
        inputs.self.modules.nixos.audiobookshelf-persistence
        inputs.self.modules.nixos.audiobookshelf-deployment
        inputs.self.modules.nixos.audiobookshelf-services
      ];

      options = {
        media-server.audiobookshelf.enable = lib.mkEnableOption "Audiobookshelf deployment on k3s";
      };
    };
}
