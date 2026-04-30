{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-homepage-settings =
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
            kind = "ConfigMap";
            metadata = {
              name = "homepage-settings";
              namespace = "homepage";
            };
            data."settings.yaml" = builtins.toJSON {
              title = "Homelab";
              theme = "dark";
              providers = {
                longhorn.url = "http://192.168.1.201";
              };
            };
          }
        ];
      };
    };
}
