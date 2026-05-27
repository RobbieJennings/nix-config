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
          garage.replicationFactor = 1;
          deployment.replicaCount = 1;
          resources = config.server.resources.profiles.appSmall;
        };
      };
    };
}
