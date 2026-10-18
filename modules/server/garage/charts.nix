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
        rev = "v2.4.1";
        hash = "sha256-+3w4R0IGxc7GCVW3t7Izt6Y5PVUjxHsdLrr74ckR9Mg=";
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
