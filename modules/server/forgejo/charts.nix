{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      forgejoChart = {
        name = "forgejo";
        repo = "oci://code.forgejo.org/forgejo-helm/forgejo";
        version = "17.3.1";
        hash = "sha256-WBbq1M8UhYIiVmS6U994KM+tE2ryo2x+URYDEV8QPWI=";
      };
    in
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s.autoDeployCharts = {
          forgejo = forgejoChart // {
            targetNamespace = "forgejo";
            createNamespace = true;
          };
        };
      };
    };
}
