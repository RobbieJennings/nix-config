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
        name = "kubernetes-operator";
        repo = "https://netbirdio.github.io/helms";
        version = "0.3.1";
        hash = "sha256-MWO1YYzbXxT+OCmjAeGchsp1bl/Dw4D0TQKXHlwIvw0=";
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
