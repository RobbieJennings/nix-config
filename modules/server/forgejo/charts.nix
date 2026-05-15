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
        version = "17.1.0";
        hash = "sha256-lim/fR/JtAdVq06wjIElsfGk8KDcMrhFJwv8EOBUkps=";
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
