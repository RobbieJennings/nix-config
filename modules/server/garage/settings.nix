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
          image =
            let
              image = inputs.self.lib.findImageByName "dxflrs/amd64_garage" config.services.k3s.images;
            in
            {
              repository = image.imageName;
              tag = image.imageTag;
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
