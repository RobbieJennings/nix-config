{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.transmission =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.transmission-images
        inputs.self.modules.nixos.transmission-persistence
        inputs.self.modules.nixos.transmission-deployment
        inputs.self.modules.nixos.transmission-services
      ];

      options = {
        media-server.transmission.enable = lib.mkEnableOption "Transmission deployment on k3s";
      };
    };
}
