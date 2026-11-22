{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.garage.enable {
        services.k3s.autoDeployCharts.garage.values = {
          image = {
            repository = config._module.args.garageImages.garageImage.imageName;
            tag = config._module.args.garageImages.garageImage.imageTag;
          };
          service.s3.web.port = 80;
          garage.replicationFactor = 1;
          deployment.replicaCount = 1;
          persistence = {
            enabled = true;
            meta.storageClass = "";
            data.storageClass = "";
          };
          resources = config.server.resources.profiles.appSmall;
        };
      };
    };
}
