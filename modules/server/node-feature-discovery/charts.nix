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
        version = "0.18.3";
        hash = "sha256-g6MnrWFUW8ibMZ6U9RdepNJlybb/qigyryoKhTiUCd4=";
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
