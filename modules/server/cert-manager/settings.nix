{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.cert-manager-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.cert-manager.enable {
        services.k3s.autoDeployCharts.cert-manager.values = {
          installCRDs = true;
          resources = config.server.resources.profiles.infraMedium;
          webhook = {
            image = {
              repository =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "quay.io/jetstack/cert-manager-webhook"
                ) null null config.services.k3s.images).imageName;
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "quay.io/jetstack/cert-manager-webhook"
                ) null null config.services.k3s.images).imageTag;
            };
            resources = config.server.resources.profiles.infraMedium;
          };
          cainjector = {
            image = {
              repository =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "quay.io/jetstack/cert-manager-cainjector"
                ) null null config.services.k3s.images).imageName;
              tag =
                (lib.lists.findSingle (
                  x: x ? imageName && x.imageName == "quay.io/jetstack/cert-manager-cainjector"
                ) null null config.services.k3s.images).imageTag;
            };
            resources = config.server.resources.profiles.infraMini;
          };
        };
      };
    };
}
