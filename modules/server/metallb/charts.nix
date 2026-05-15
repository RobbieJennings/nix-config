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
        version = "0.15.3";
        hash = "sha256-J9t2HFrSUl/RMMkv4vLUUA+IcOQC/v48nLjTTYpxpww=";
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
