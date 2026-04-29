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
        services.k3s.autoDeployCharts.nextcloud.values = {
          persistence = {
            enabled = true;
            size = "8Gi";
            nextcloudData = {
              enabled = true;
              size = "25Gi";
            };
          };
        };
      };
    };
}
