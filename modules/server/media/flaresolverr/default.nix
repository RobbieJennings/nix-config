{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.flaresolverr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.flaresolverr-images
        inputs.self.modules.nixos.flaresolverr-deployment
        inputs.self.modules.nixos.flaresolverr-services
      ];

      options = {
        media-server.flaresolverr.enable = lib.mkEnableOption "Flaresolverr deployment on k3s";
      };
    };
}
