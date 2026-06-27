{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.metallb-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      metallbChart = {
        name = "metallb";
        repo = "https://metallb.github.io/metallb";
        version = "0.16.1";
        hash = "sha256-+wa7WE/LeFbxVzOypqKv9bYbXDUGh+NBwWOuJKWTitw=";
      };
    in
    {
      config = lib.mkIf config.metallb.enable {
        services.k3s.autoDeployCharts = {
          metallb = metallbChart // {
            targetNamespace = "metallb-system";
            createNamespace = true;
          };
        };
      };
    };
}
