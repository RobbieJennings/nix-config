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
        version = "17.1.1";
        hash = "sha256-JqoxIOAgtnWTzm4iZsRX7pJf9RT2BlY+GEsJ7WWB4Y8=";
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
