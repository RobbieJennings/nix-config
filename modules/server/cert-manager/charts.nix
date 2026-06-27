{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.cert-manager-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      certManagerChart = {
        name = "cert-manager";
        repo = "https://charts.jetstack.io";
        version = "v1.20.3";
        hash = "sha256-711wf1r7ssPOmJL1/z/KDexoZNuIMKHEVLPUgixIWEM=";
      };
    in
    {
      config = lib.mkIf config.cert-manager.enable {
        services.k3s.autoDeployCharts = {
          cert-manager = certManagerChart // {
            targetNamespace = "cert-manager";
            createNamespace = true;
          };
        };
      };
    };
}
