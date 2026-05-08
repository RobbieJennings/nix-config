{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.blog-namespace =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.blog.enable {
        services.k3s.manifests.blog.content = [
          {
            apiVersion = "v1";
            kind = "Namespace";
            metadata = {
              name = "website";
            };
          }
        ];
      };
    };
}
