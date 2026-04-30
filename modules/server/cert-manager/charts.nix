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
        version = "v1.19.4";
        hash = "sha256-0MIC9XuGU+uVf7Wy+UcsGxHPa1Gsxcd35Lgk97Wp6oc=";
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
