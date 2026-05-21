{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.node-feature-discovery-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.node-feature-discovery.enable {
        services.k3s.autoDeployCharts.node-feature-discovery.values = {
          master = {
            resources = config.server.resources.profiles.infraMini;
          };
          worker = {
            resources = config.server.resources.profiles.infraMini;
          };
          gc = {
            resources = config.server.resources.profiles.infraMini;
          };
        };
      };
    };
}
