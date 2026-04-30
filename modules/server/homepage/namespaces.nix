{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-namespace =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.homepage.enable {
        services.k3s.manifests.homepage.content = [
          {
            apiVersion = "v1";
            kind = "Namespace";
            metadata = {
              name = "homepage";
            };
          }
        ];
      };
    };
}
