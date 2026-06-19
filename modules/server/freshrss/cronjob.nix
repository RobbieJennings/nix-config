{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-cronjob =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.freshrss.enable {
        services.k3s.manifests.freshrss.content = [
          {
            apiVersion = "batch/v1";
            kind = "CronJob";
            metadata = {
              name = "freshrss-update";
              namespace = "freshrss";
            };
            spec = {
              schedule = "*/15 * * * *";
              concurrencyPolicy = "Forbid";
              successfulJobsHistoryLimit = 1;
              failedJobsHistoryLimit = 3;
              jobTemplate.spec.template.spec = {
                restartPolicy = "OnFailure";
                containers = [
                  {
                    name = "update";
                    image =
                      let
                        image = inputs.self.lib.findImageByName "linuxserver/freshrss" config.services.k3s.images;
                      in
                      "${image.imageName}:${image.imageTag}";
                    command = [
                      "/usr/bin/php"
                      "/app/www/app/actualize_script.php"
                    ];
                    env = [
                      {
                        name = "PUID";
                        value = "1000";
                      }
                      {
                        name = "PGID";
                        value = "1000";
                      }
                      {
                        name = "TZ";
                        value = "UTC";
                      }
                    ];
                    volumeMounts = [
                      {
                        name = "config";
                        mountPath = "/config";
                      }
                    ];
                    resources = config.server.resources.profiles.appSmall;
                  }
                ];
                volumes = [
                  {
                    name = "config";
                    persistentVolumeClaim.claimName = "freshrss-pvc";
                  }
                ];
              };
            };
          }
        ];
      };
    };
}
