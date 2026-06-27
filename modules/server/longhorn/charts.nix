{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      longhornChart = {
        name = "longhorn";
        repo = "https://charts.longhorn.io";
        version = "1.12.0";
        hash = "sha256-hpuyBwGxVEc2BvHolnsn808kSKLf5uuJcPHK5pVzhPU=";
      };
    in
    {
      config = lib.mkIf config.longhorn.enable {
        services.k3s.autoDeployCharts = {
          longhorn = longhornChart // {
            targetNamespace = "longhorn-system";
            createNamespace = true;
          };
        };
      };
    };
}
