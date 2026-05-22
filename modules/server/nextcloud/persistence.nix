{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-persistence =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.nextcloud.enable {
        system.activationScripts.createNextcloudDirs = ''
          mkdir -p /storage/nextcloud
          chown 1000:1000 /storage/nextcloud
          chmod 775 /storage/nextcloud
        '';
        services.k3s.autoDeployCharts.nextcloud.values = {
          persistence = {
            enabled = true;
            size = "8Gi";
            nextcloudData = {
              enabled = true;
              size = "100Gi";
              hostPath = "/storage/nextcloud";
            };
          };
        };
      };
    };
}
