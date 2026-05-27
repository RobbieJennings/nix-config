{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      src = pkgs.fetchgit {
        url = "https://git.deuxfleurs.fr/Deuxfleurs/garage.git";
        rev = "v2.3.0";
        hash = "sha256-CqHcaVGgXL/jjqq7XN+kzEp6xoNgwBfGpMKYbTd78Ys=";
      };
      chart =
        pkgs.runCommand "garage-chart.tgz"
          {
            nativeBuildInputs = [ pkgs.kubernetes-helm ];
          }
          ''
            helm package ${src}/script/helm/garage --destination .
            mv garage-*.tgz $out
          '';
    in
    {
      config = lib.mkIf config.garage.enable {
        services.k3s.autoDeployCharts = {
          garage = {
            package = chart;
            targetNamespace = "garage";
            createNamespace = true;
          };
        };
      };
    };
}
