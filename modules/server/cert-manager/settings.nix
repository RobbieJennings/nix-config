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
          image =
            let
              image = inputs.self.lib.findImageByName "quay.io/jetstack/cert-manager-controller" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
            };
          startupapicheck.image =
            let
              image = inputs.self.lib.findImageByName "quay.io/jetstack/cert-manager-startupapicheck" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
            };
          acmesolver.image =
            let
              image = inputs.self.lib.findImageByName "quay.io/jetstack/cert-manager-acmesolver" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
            };
          webhook = {
            image =
              let
                image = inputs.self.lib.findImageByName "quay.io/jetstack/cert-manager-webhook" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
              };
            resources = config.server.resources.profiles.infraMedium;
          };
          cainjector = {
            image =
              let
                image = inputs.self.lib.findImageByName "quay.io/jetstack/cert-manager-cainjector" config.services.k3s.images;
              in
              {
                repository = image.imageName;
                tag = image.imageTag;
              };
            resources = config.server.resources.profiles.infraMini;
          };
        };
      };
    };
}
