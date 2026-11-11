{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.shelfmark =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.shelfmark-images
        inputs.self.modules.nixos.shelfmark-persistence
        inputs.self.modules.nixos.shelfmark-deployment
        inputs.self.modules.nixos.shelfmark-services
      ];

      options = {
        media-server.shelfmark.enable = lib.mkEnableOption "Shelfmark deployment on k3s";
      };
    };
}
