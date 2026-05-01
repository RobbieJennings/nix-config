{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prowlarr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.prowlarr-images
        inputs.self.modules.nixos.prowlarr-persistence
        inputs.self.modules.nixos.prowlarr-deployment
        inputs.self.modules.nixos.prowlarr-services
      ];

      options = {
        media-server.prowlarr.enable = lib.mkEnableOption "Prowlarr deployment on k3s";
      };
    };
}
