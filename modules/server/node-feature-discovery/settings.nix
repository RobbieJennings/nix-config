{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.node-feature-discovery-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.node-feature-discovery = {
        masterResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraMini;
          description = "Resource profile for Node Feature Discovery's master instance";
        };
        workerResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraMini;
          description = "Resource profile for Node Feature Discovery's worker instance";
        };
        gcResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraMini;
          description = "Resource profile for Node Feature Discovery's garbage collector instance";
        };
      };

      config = lib.mkIf config.node-feature-discovery.enable {
        services.k3s.autoDeployCharts.node-feature-discovery.values = {
          image = {
            repository = config._module.args.nodeFeatureDiscoveryImages.nodeFeatureDiscoveryImage.imageName;
            tag = config._module.args.nodeFeatureDiscoveryImages.nodeFeatureDiscoveryImage.imageTag;
          };
          master.resources = config.node-feature-discovery.masterResources;
          worker.resources = config.node-feature-discovery.workerResources;
          gc.resources = config.node-feature-discovery.gcResources;
        };
      };
    };
}
