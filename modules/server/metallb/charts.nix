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
        version = "0.15.2";
        hash = "sha256-Tw/DE82XgZoceP/wo4nf4cn5i8SQ8z9SExdHXfHXuHM=";
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
