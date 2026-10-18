{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.node-feature-discovery-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      nodeFeatureDiscoveryChart = {
        name = "node-feature-discovery";
        repo = "oci://registry.k8s.io/nfd/charts/node-feature-discovery";
        version = "0.20.0";
        hash = "sha256-/5Lbr1NHCGmjLnPab0YkaiBUS1Fw0wIa7Il6iMzWrOI=";
      };
    in
    {
      config = lib.mkIf config.node-feature-discovery.enable {
        services.k3s.autoDeployCharts = {
          node-feature-discovery = nodeFeatureDiscoveryChart // {
            targetNamespace = "node-feature-discovery";
            createNamespace = true;
          };
        };
      };
    };
}
