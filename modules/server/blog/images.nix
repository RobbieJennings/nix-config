{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.blog-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      blogImage = inputs.blog.packages."x86_64-linux".dockerImage;
    in
    {
      config = lib.mkIf config.blog.enable {
        services.k3s = {
          images = [ blogImage ];
        };
      };
    };
}
