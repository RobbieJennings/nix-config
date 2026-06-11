{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.netbird-operator.enable {
        services.k3s.autoDeployCharts.netbird-operator.values = {
          operator.image =
            let
              image = inputs.self.lib.findImageByName "ghcr.io/netbirdio/netbird-operator" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
            };
          routingClientImage =
            let
              image = inputs.self.lib.findImageByName "ghcr.io/netbirdio/netbird" config.services.k3s.images;
            in
            "${image.imageName}:${image.imageTag}";
          resources = config.server.resources.profiles.infraLarge;
        };
      };
    };
}
