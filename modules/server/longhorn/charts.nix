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
        version = "1.13.0";
        hash = "sha256-5X8BDSqLzw2luLA//s9Jxbw13cJmNYjOjyK3VnthM+0=";
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
