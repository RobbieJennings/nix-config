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
        version = "0.4.1";
        hash = "sha256-gRdZViio1QZYNlaEEKk/36F0wc3MnMgtTZE2HTIx4qo=";
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
