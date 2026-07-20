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
        version = "0.8.0";
        hash = "sha256-YbxJ6Nd1mA9SomYrTFZV8Xf/PovnGJaUzmpXCUg1mdE=";
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
