{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-charts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      nextcloudChart = {
        name = "nextcloud";
        repo = "https://nextcloud.github.io/helm";
        version = "9.4.1";
        hash = "sha256-49dohkgAvMI+tm5vZcv18FRbFQbPjGX1WpHSGvO61L8=";
      };
    in
    {
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.autoDeployCharts = {
          nextcloud = nextcloudChart // {
            targetNamespace = "nextcloud";
            createNamespace = true;
          };
        };
      };
    };
}
