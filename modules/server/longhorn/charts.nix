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
        version = "1.10.1";
        hash = "sha256-qHHTl+Gc8yQ5SavUH9KUhp9cLEkAFPKecYZqJDPsf7k=";
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
