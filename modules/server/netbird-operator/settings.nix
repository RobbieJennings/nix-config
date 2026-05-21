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
          resources = config.server.resources.profiles.infraLarge;
        };
      };
    };
}
