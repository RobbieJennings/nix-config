{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-backup-job =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.longhorn.enable {
        services.k3s.autoDeployCharts.longhorn.extraDeploy = [
          {
            apiVersion = "longhorn.io/v1beta2";
            kind = "RecurringJob";
            metadata = {
              name = "daily-backup";
              namespace = "longhorn-system";
            };
            spec = {
              cron = "0 0 * * *";
              task = "backup";
              groups = [ "default" ];
              retain = 1;
              concurrency = 2;
            };
          }
        ];
      };
    };
}
