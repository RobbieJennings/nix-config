{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.blog =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.blog-namespace
        inputs.self.modules.nixos.blog-images
        inputs.self.modules.nixos.blog-deployment
        inputs.self.modules.nixos.blog-services
      ];

      options = {
        blog.enable = lib.mkEnableOption "Blog deployment on k3s";
      };
    };
}
