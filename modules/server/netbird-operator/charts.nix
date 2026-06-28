{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      netbirdOperatorChart = {
        name = "netbird-operator";
        repo = "oci://ghcr.io/netbirdio/helm-charts/netbird-operator";
        version = "0.7.0";
        hash = "sha256-5/uW/ufWfSKT8ZlLZEVY2pXqxAS8es0L1VV5/xd8byo=";
      };
    in
    {
      config = lib.mkIf config.netbird-operator.enable {
        services.k3s.autoDeployCharts = {
          netbird-operator = netbirdOperatorChart // {
            targetNamespace = "netbird";
            createNamespace = true;
          };
        };
      };
    };
}
