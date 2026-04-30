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
          resources = {
            requests.cpu = "100m";
            requests.memory = "128Mi";
            limits.cpu = "250m";
            limits.memory = "256Mi";
          };
        };
      };
    };
}
