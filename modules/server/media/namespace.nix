{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.media-namespace =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.media-server.enable {
        services.k3s.manifests.media.content = [
          {
            apiVersion = "v1";
            kind = "Namespace";
            metadata = {
              name = "media";
            };
          }
        ];
      };
    };
}
