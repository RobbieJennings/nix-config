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
      blogImages = {
        blogImage = inputs.blog.packages."x86_64-linux".dockerImage;
      };
    in
    {
      config = {
        _module.args.blogImages = blogImages;
        services.k3s = lib.mkIf config.blog.enable {
          images = builtins.attrValues blogImages;
        };
      };
    };
}
