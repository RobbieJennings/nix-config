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
            resources = {
              requests.cpu = "10m";
              requests.memory = "32Mi";
              limits.cpu = "100m";
              limits.memory = "64Mi";
            };
          };
          worker = {
            resources = {
              requests.cpu = "10m";
              requests.memory = "32Mi";
              limits.cpu = "100m";
              limits.memory = "64Mi";
            };
          };
          gc = {
            resources = {
              requests.cpu = "5m";
              requests.memory = "16Mi";
              limits.cpu = "50m";
              limits.memory = "32Mi";
            };
          };
        };
      };
    };
}
