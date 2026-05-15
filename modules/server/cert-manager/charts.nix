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
        version = "v1.20.2";
        hash = "sha256-0qUL1EoJ2DjCV2qPPfyhUkWXxzk8+Ngqs+yKRlue63k=";
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
