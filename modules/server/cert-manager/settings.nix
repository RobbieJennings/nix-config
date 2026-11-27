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
      options.cert-manager = {
        certManagerResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraMedium;
          description = "Resource profile for cert-manager";
        };
        webhookResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraMedium;
          description = "Resource profile for cert-manager's webhook";
        };
        cainjectorResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraSmall;
          description = "Resource profile for cert-manager's ca-injector";
        };
      };

      config = lib.mkIf config.cert-manager.enable {
        services.k3s.autoDeployCharts.cert-manager.values = {
          installCRDs = true;
          resources = config.cert-manager.certManagerResources;
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
            resources = config.cert-manager.webhookResources;
          };
          cainjector = {
            image = {
              repository = config._module.args.certManagerImages.cainjectorImage.imageName;
              tag = config._module.args.certManagerImages.cainjectorImage.imageTag;
            };
            resources = config.cert-manager.cainjectorResources;
          };
        };
      };
    };
}
