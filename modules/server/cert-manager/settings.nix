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
          image = {
            repository = config._module.args.certManagerImages.controllerImage.imageName;
            tag = config._module.args.certManagerImages.controllerImage.imageTag;
          };
          startupapicheck.image = {
            repository = config._module.args.certManagerImages.startupapicheckImage.imageName;
            tag = config._module.args.certManagerImages.startupapicheckImage.imageTag;
          };
          acmesolver.image = {
            repository = config._module.args.certManagerImages.acmesolverImage.imageName;
            tag = config._module.args.certManagerImages.acmesolverImage.imageTag;
          };
          webhook = {
            image = {
              repository = config._module.args.certManagerImages.webhookImage.imageName;
              tag = config._module.args.certManagerImages.webhookImage.imageTag;
            };
            resources = config.server.resources.profiles.infraMedium;
          };
          cainjector = {
            image = {
              repository = config._module.args.certManagerImages.cainjectorImage.imageName;
              tag = config._module.args.certManagerImages.cainjectorImage.imageTag;
            };
            resources = config.server.resources.profiles.infraSmall;
          };
        };
      };
    };
}
