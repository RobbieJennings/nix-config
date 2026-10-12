{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.seerr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.seerr-images
        inputs.self.modules.nixos.seerr-persistence
        inputs.self.modules.nixos.seerr-deployment
        inputs.self.modules.nixos.seerr-services
      ];

      options = {
        media-server.seerr.enable = lib.mkEnableOption "Seerr deployment on k3s";
      };
    };
}
