{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.calibre-web-automated =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.calibre-web-automated-images
        inputs.self.modules.nixos.calibre-web-automated-persistence
        inputs.self.modules.nixos.calibre-web-automated-deployment
        inputs.self.modules.nixos.calibre-web-automated-services
      ];

      options = {
        media-server.calibre-web-automated.enable = lib.mkEnableOption "Calibre-Web-Automated deployment on k3s";
      };
    };
}
