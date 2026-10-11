{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      immichChart = {
        name = "immich";
        repo = "oci://ghcr.io/immich-app/immich-charts/immich";
        version = "0.13.4";
        hash = "sha256-p3Q9Qz/pnSNQPHunp0l5ndl+MstRfRS1l2/CPi6QHys=";
      };
    in
    {
      config = lib.mkIf config.immich.enable {
        services.k3s.autoDeployCharts = {
          immich = immichChart // {
            targetNamespace = "immich";
            createNamespace = true;
          };
        };
      };
    };
}
