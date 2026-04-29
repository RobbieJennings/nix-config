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
        version = "16.2.2";
        hash = "sha256-l8sEgEmCItMQO1be7wzTcQ/rsIIJK4tG7+jxItrAgo8=";
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
