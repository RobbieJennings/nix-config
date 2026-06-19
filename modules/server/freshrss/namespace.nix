{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-namespace =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.freshrss.enable {
        services.k3s.manifests.freshrss.content = [
          {
            apiVersion = "v1";
            kind = "Namespace";
            metadata = {
              name = "freshrss";
            };
          }
        ];
      };
    };
}
