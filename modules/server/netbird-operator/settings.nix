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
          operator.image = {
            repository = config._module.args.netbirdImages.operatorImage.imageName;
            tag = config._module.args.netbirdImages.operatorImage.imageTag;
          };
          routingClientImage = "${config._module.args.netbirdImages.routerImage.imageName}:${config._module.args.netbirdImages.routerImage.imageTag}";
          resources = config.server.resources.profiles.infraLarge;
        };
      };
    };
}
