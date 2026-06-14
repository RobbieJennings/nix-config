{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-valkey =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts.nextcloud.extraDeploy = [
          {
            apiVersion = "valkey.io/v1alpha1";
            kind = "ValkeyCluster";
            metadata = {
              namespace = "nextcloud";
              name = "nextcloud-valkey";
            };
            spec = {
              image =
                let
                  image = inputs.self.lib.findImageByName "valkey/valkey" config.services.k3s.images;
                in
                "${image.imageName}:${image.imageTag}";
              shards = 1;
              replicas = 0;
              users = [
                {
                  name = "nextcloud";
                  permissions = "+@all ~* &*";
                  passwordSecret = {
                    name = "nextcloud-secrets";
                    keys = [ "valkey-password" ];
                  };
                }
              ];
              resources = config.server.resources.profiles.cache;
              exporter = {
                enabled = true;
                image =
                  let
                    image = inputs.self.lib.findImageByName "oliver006/redis_exporter" config.services.k3s.images;
                  in
                  "${image.imageName}:${image.imageTag}";
                resources = config.server.resources.profiles.infraSmall;
              };
            };
          }
        ];
      };
    };
}
